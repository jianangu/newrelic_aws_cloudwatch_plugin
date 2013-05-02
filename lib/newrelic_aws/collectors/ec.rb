module NewRelicAWS
  module Collectors
    class EC < Base
      def clusters
        ec = AWS::ElastiCache.new(
          :access_key_id => @aws_access_key,
          :secret_access_key => @aws_secret_key,
          :region => @aws_region
        )
        clusters = ec.client.describe_cache_clusters(:show_cache_node_info => true)
        clusters[:cache_clusters].map do |cluster|
          {
            :id    => cluster[:cache_cluster_id],
            :nodes => cluster[:cache_nodes].map { |node| node[:cache_node_id] }
          }
        end
      end

      def metric_list
        {
          "CPUUtilization"               => "Percent",
          "SwapUsage"                    => "Bytes",
          "FreeableMemory"               => "Bytes",
          "NetworkBytesIn"               => "Bytes",
          "NetworkBytesOut"              => "Bytes",
          "BytesUsedForCacheItems"       => "Bytes",
          "BytesReadIntoMemcached"       => "Bytes",
          "BytesWrittenOutFromMemcached" => "Bytes",
          "CasBadval"                    => "Count",
          "CasHits"                      => "Count",
          "CasMisses"                    => "Count",
          "CmdFlush"                     => "Count",
          "CmdGet"                       => "Count",
          "CmdSet"                       => "Count",
          "CurrConnections"              => "Count",
          "CurrItems"                    => "Count",
          "DecrHits"                     => "Count",
          "DecrMisses"                   => "Count",
          "DeleteHits"                   => "Count",
          "DeleteMisses"                 => "Count",
          "Evictions"                    => "Count",
          "GetHits"                      => "Count",
          "GetMisses"                    => "Count",
          "IncrHits"                     => "Count",
          "IncrMisses"                   => "Count",
          "Reclaimed"                    => "Count",
          "BytesUsedForHash"             => "Bytes",
          "CmdConfigGet"                 => "Count",
          "CmdConfigSet"                 => "Count",
          "CmdTouch"                     => "Count",
          "CurrConfig"                   => "Count",
          "EvictedUnfetched"             => "Count",
          "ExpiredUnfetched"             => "Count",
          "SlabsMoved"                   => "Count",
          "TouchHits"                    => "Count",
          "TouchMisses"                  => "Count",
          "NewConnections"               => "Count",
          "NewItems"                     => "Count",
          "UnusedMemory"                 => "Bytes"
        }
      end

      def collect
        data_points = []
        clusters.each do |cluster|
          metric_list.each do |metric_name, unit|
            cluster[:nodes].each do |node_id|
              data_point = get_data_point(
                :namespace   => "AWS/ElastiCache",
                :metric_name => metric_name,
                :unit        => unit,
                :dimensions  => [
                  {
                    :name  => "CacheClusterId",
                    :value => cluster[:id]
                  },
                  {
                    :name => "CacheNodeId",
                    :value => node_id
                  }
                ]
              )
              unless data_point.nil?
                data_points << data_point
              end
            end
          end
        end
        data_points
      end
    end
  end
end
