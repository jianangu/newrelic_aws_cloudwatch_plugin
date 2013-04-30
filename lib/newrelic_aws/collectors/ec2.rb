module NewRelicAWS
  module Collectors
    class EC2 < Base
      def instances
        ec2 = AWS::EC2.new(
          :access_key_id => @aws_access_key,
          :secret_access_key => @aws_secret_key,
          :region => @aws_region
        )
        ec2.instances
      end

      def metric_list
        {
          "CPUUtilization" => "Percent",
          "DiskReadOps"    => "Count",
          "DiskWriteOps"   => "Count",
          "DiskWriteBytes" => "Bytes",
          "NetworkIn"      => "Bytes",
          "NetworkOut"     => "Bytes"
        }
      end

      def collect
        data_points = []
        instances.each do |instance|
          detailed = instance.monitoring == :enabled
          metric_list.each do |metric_name, unit|
            data_point = get_data_point(
              :namespace   => "AWS/EC2",
              :metric_name => metric_name,
              :unit        => unit,
              :dimension   => {
                :name  => "InstanceId",
                :value => instance.id
              },
              :period => detailed ? 60 : 300,
              :start_time => (Time.now.utc-(detailed ? 120 : 360)).iso8601
            )
            unless data_point.nil?
              data_points << data_point
            end
          end
        end
        data_points
      end
    end
  end
end
