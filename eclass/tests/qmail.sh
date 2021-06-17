#!/bin/bash
# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh

inherit qmail

# some numbers are blocked because they are to small even if prime
test_low_numbers() {
	tbegin "low numbers"

	for i in $(seq 0 6); do
		if is_prime ${i}; then
			return tend 1 "${i} badly accepted"
		fi
	done

	tend 0
}

# test a given number for being prime
check_prime_number() {
	# use factor from coreutils to count the factors
	if [[ $(factor $1 | cut -d: -f2 | wc -w) == 1 ]]; then
		return $(is_prime $1)
	else
		return $(is_prime $1 && false || true)
	fi
}

test_primes() {
	tbegin "factorizations from ${1} to ${2}"

	for i in $(seq ${1:?} ${2:?}); do
		if ! check_prime_number $i; then
			tend 1 "${i} returned bad factorization"
			return 1
		fi
	done

	tend 0
}

test_low_numbers
test_primes 7 99
for i in $(seq 100 100 1000); do
	test_primes $i $((i + 99))
done

texit
