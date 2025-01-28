#!/bin/bash

cpu_usage(){
    echo "Использование ЦП:"
    top -bn1 | grep "%Cpu(s):" | cut -d ',' -f 4 | awk '{print "Использовано: " 100-$1 "%"}'
}

mem_usage(){
    echo "Использование памяти:"
    free -h | awk '/Mem:/ {printf "Использовано: %.2f%%\n", $3/$2 * 100.0; printf "Свободно: %.2f%%\n", $4/( $2 * 1000 ) * 100.0}'
}

disk_usage(){
    echo "Использование диска:"
    df -h | grep "/" -w | awk '{printf "Всего: %sG\nИспользовано: %s (%.2f%%)\nСвободно: %s (%.2f%%)\n",$3 + $4, $3, $3/($3+$4) * 100, $4, $4/($3+$4) * 100}'
}

processes_cpu(){
    echo "5 основных процессов по использованию ЦП:"
    ps aux --sort=-%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'
}

processes_mem(){
    echo "5 основных процессов по использованию памяти:"
    ps aux --sort=-%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Статистика производительности сервера:"
    cpu_usage
    mem_usage
    disk_usage
    processes_cpu
    processes_mem
fi

