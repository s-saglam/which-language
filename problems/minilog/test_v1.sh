#!/usr/bin/env bash

# Mini-log SPEC v1 test script
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
  rm -f sample.log
}

######################################
# Setup
######################################
cleanup
mkdir testenv
cd testenv

# Örnek log dosyası oluşturma
cat <<EOF > sample.log
2025-11-10 10:35:02 ERROR Database connection failed
2025-11-10 10:36:00 INFO System started
2025-11-10 10:37:05 ERROR Timeout
2025-11-10 10:38:10 WARNING Low disk space
EOF

# Program yolu (Üst dizindeki Mini-log.py)
MINILOG="python3 ../Mini-log.py"

######################################
# Test 1: logs komutu (Toplam satır sayısı)
######################################
output=$($MINILOG logs sample.log)
if [[ "$output" == *"4"* ]]; then
  pass "logs command returns correct count"
else
  fail "logs command (Expected 4, got: $output)"
fi

######################################
# Test 2: count komutu (Level bazlı sayım)
######################################
output=$($MINILOG count ERROR sample.log)
if [[ "$output" == *"2"* ]]; then
  pass "count ERROR returns correct count"
else
  fail "count ERROR (Expected 2, got: $output)"
fi

######################################
# Test 3: filter komutu (Level filtreleme)
######################################
output=$($MINILOG filter ERROR sample.log)
if echo "$output" | grep -q "Database connection failed" && echo "$output" | grep -q "Timeout"; then
  pass "filter ERROR returns correct logs"
else
  fail "filter ERROR did not return expected logs"
fi

######################################
# Test 4: find komutu (Kelime arama)
######################################
output=$($MINILOG find "Database" sample.log)
if echo "$output" | grep -q "2025-11-10 10:35:02 ERROR Database connection failed"; then
  pass "find keyword returns matching line"
else
  fail "find keyword failed"
fi

######################################
# Test 5: Hata Yönetimi (Eksik dosya)
######################################
output=$($MINILOG logs 2>&1)
if echo "$output" | grep -iq "file name is missing"; then
  pass "Error handling: Missing file name"
else
  fail "Error handling: Missing file name"
fi

######################################
# Cleanup & Summary
######################################
cd ..
cleanup

echo ""
echo "========================"
echo "V1 PASSED: $PASS_COUNT"
echo "V1 FAILED: $FAIL_COUNT"
echo "========================"

[ "$FAIL_COUNT" -eq 0 ] || exit 1
