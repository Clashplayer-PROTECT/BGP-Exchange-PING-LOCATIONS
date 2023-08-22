#!/bin/bash

cities=(
    "Buenos Aires, Argentina, 190.103.176.85"
    "Melbourne, Australia, 119.42.53.232"
    "Sydney, Australia, 103.180.192.28"
    "Brisbane, Australia, 203.57.51.161"
    "Perth, Australia, 203.29.242.33"
    "Fortaleza, Brazil, 170.80.110.85"
    "Rio de Janeiro, Brazil, 170.80.109.85"
    "Sao Paulo, Brazil, 170.80.108.160"
    "Toronto, Canada, 103.144.177.73"
    "Zurich, Switzerland, 193.148.250.154"
    "Valdivia, Chile, 216.73.159.104"
    "Bogata, Colombia, 190.120.231.85"
    "Frankfurt, Germany, 193.148.249.248"
    "Dusseldorf, Germany, 194.28.99.186"
    "Dusseldorf, Germany, 5.105.6.31"
    "Berlin, Germany, 195.191.196.97"
    "Quito, Ecuador, 179.49.5.72"
    "Barcelona, Spain, 45.134.91.152"
    "Lyon, France, 45.145.167.101"
    "Paris, France, 45.13.105.239"
    "Civrieux, France, 45.137.27.70"
    "London, United Kingdom, 45.134.88.112"
    "Accra, Ghana, 169.255.56.165"
    "Rome, Italy, 152.89.170.251"
    "Ponte San Pietro, Italy, 80.211.123.152"
    "Mexico City, Mexico, 190.103.179.85"
    "Amsterdam, Netherlands, 193.148.248.30"
    "Oslo, Norway, 45.134.89.120"
    "Auckland, New Zealand, 185.99.133.211"
    "Panama City, Panama, 138.186.142.85"
    "Lima, Peru, 190.120.229.75"
    "Singapore, Singapore, 103.180.193.22"
    "Taipei, Taiwan, 216.146.28.12"
    "Kyiv, Ukraine, 193.218.118.58"
    "Los Angeles, United States, 23.234.228.189"
    "Houston, United States, 193.148.251.135"
    "Kansas City, United States, 23.152.226.68"
    "Atlanta, United States, 23.95.90.235"
    "Jacksonville, United States, 134.195.139.24"
    "Seattle, United States, 104.168.83.44"
    "Fremont, United States, 185.44.83.38"
    "Miami, United States, 190.103.178.85"
   )

output_file="ping_results.txt"

ping_city() {
    city_info="$1"
    city_name=$(echo "$city_info" | awk -F', ' '{print $1}')
    country=$(echo "$city_info" | awk -F', ' '{print $2}')
    ip=$(echo "$city_info" | awk -F', ' '{print $3}')
    avg_latency=$(ping -c 4 "$ip" | grep "rtt" | awk -F'/' '{print $5}')

    if [ -n "$avg_latency" ]; then
        if [ $(awk 'BEGIN {print ('$avg_latency' > 40)}') -eq 1 ]; then
            echo "$city_name, $country, $ip - ❌ ($avg_latency ms)" >> "$output_file"
        else
            echo "$city_name, $country, $ip - ✅ ($avg_latency ms)" >> "$output_file"
        fi
    else
        echo "$city_name, $country, $ip - ($avg_latency ms)" >> "$output_file"
    fi

    echo "$(tail -n 1 $output_file)"
}

rm -f "$output_file"

echo "Pinging all locations. Please wait..."

for city_info in "${cities[@]}"; do
    ping_city "$city_info" &
done

wait

echo "All locations have been pinged. Results have been saved to $output_file"

cat "$output_file"
