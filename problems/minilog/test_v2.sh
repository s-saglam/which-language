#!/usr/bin/env bash

# Mini-log SPEC v2 test script
set -e

PASS_COUNT=0
FAIL_COUNT=0

fail() {
  echo "FAIL: $1"
  FAIL_COUNT=$((FAIL_COUNT+1))
}

pass() {
  echo "PASS: $1"
  PASS_COUNT=$((PASS_COUNT+1))
}

cleanup() {
  rm -rf testenv
}

######################################
# Setup
######################################
cleanup
mkdir testenv
cd testenv

# Zaman aralığı testi için log dosyası
cat <<EOF > v2_sample.log
2026-03-30 10:00:00 INFO Start
2026-03-30 10:05:00 ERROR Middle
2026-03-30 10:10:00 WARNING End
EOF

MINILOG="python3 ../Mini-log.py"

######################################
# Test 1: time komutu (Aralık yakalama)
######################################
# 10:00 ile 10:05 arasını sorguluyoruz (İkisi de dahil olmalı)
output=$($MINILOG time "2026-03-30 10:00:00" "2026-03-30 10:05:00" v2_sample.log)

if echo "$output" | grep -q "Start" && echo "$output" | grep -q "Middle" && ! echo "$output" | grep -q "End"; then
  pass "time command filters correct range (inclusive)"
else
  fail "time command range filter failed"
fi

######################################
# Test 2: time komutu (Tam eşleşme)
######################################
# Sadece tek bir saniyeyi sorguluyoruz
output=$($MINILOG time "2026-03-30 10:10:00" "2026-03-30 10:10:00" v2_sample.log)

if echo "$output" | grep -q "End" && [[ $(echo "$output" | wc -l) -eq 1 ]]; then
  pass "time command works with same start/stop time"
else
  fail "time command single point filter failed"
fi

######################################
# Cleanup & Summary
######################################
cd ..
cleanup

echo ""
echo "========================"
echo "V2 PASSED: $PASS_COUNT"
echo "V2 FAILED: $FAIL_COUNT"
echo "========================"

[ "$FAIL_COUNT" -eq 0 ] || exit 1
