#!/bin/bash
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

source tests-common.sh

inherit eapi8-dosym

dosym() {
	echo "$1"
}

# reference implementation using GNU realpath
ref_canonicalize() {
	realpath -m -s "$1"
}

ref_dosym_r() {
	local link=$(realpath -m -s "/${2#/}")
	realpath -m -s --relative-to="$(dirname "${link}")" "$1"
}

randompath() {
	dd if=/dev/urandom bs=128 count=1 2>/dev/null | LC_ALL=C sed \
		-e 's/[^a-zA-M]//g;s/[A-E]/\/.\//g;s/[F-J]/\/..\//g;s/[K-M]/\//g' \
		-e 's/^/\//;q'
}

teq() {
	local expected=$1; shift
	tbegin "$* -> ${expected}"
	local got=$("$@")
	[[ ${got} == "${expected}" ]]
	tend $? "returned: ${got}"
}

for f in ref_canonicalize "_dosym8_canonicalize"; do
	# canonicalize absolute paths
	teq / ${f} /
	teq /foo/baz/quux ${f} /foo/bar/../baz/quux
	teq /foo ${f} /../../../foo
	teq /bar ${f} /foo//./..///bar
	teq /baz ${f} /foo/bar/../../../baz
	teq /a/d/f/g ${f} /a/b/c/../../d/e/../f/g
done

# canonicalize relative paths (not actually used)
teq . _dosym8_canonicalize .
teq foo _dosym8_canonicalize foo
teq foo _dosym8_canonicalize ./foo
teq ../foo _dosym8_canonicalize ../foo
teq ../baz _dosym8_canonicalize foo/bar/../../../baz

for f in ref_dosym_r "dosym8 -r"; do
	teq ../../bin/foo ${f} /bin/foo /usr/bin/foo
	teq ../../../doc/foo-1 \
		${f} /usr/share/doc/foo-1 /usr/share/texmf-site/doc/fonts/foo
	teq ../../opt/bar/foo ${f} /opt/bar/foo /usr/bin/foo
	teq ../c/d/e ${f} /a/b/c/d/e a/b/f/g
	teq b/f ${f} /a/b///./c/d/../e/..//../f /a/././///g/../h
	teq ../h ${f} /a/././///g/../h /a/b///./c/d/../e/..//../f
	teq . ${f} /foo /foo/bar
	teq .. ${f} /foo /foo/bar/baz
	teq '../../fo . o/b ar' ${f} '/fo . o/b ar' '/baz / qu .. ux/qu x'
	teq '../../f"o\o/b$a[]r' ${f} '/f"o\o/b$a[]r' '/ba\z/qu$u"x/qux'
done

# set RANDOMTESTS to a positive number to enable random tests
for (( i = 0; i < RANDOMTESTS; i++ )); do
	targ=$(randompath)
	link=$(randompath)
	out=$(ref_dosym_r "${targ}" "${link}")
	teq "${out}" dosym8 -r "${targ}" "${link}"
done

texit
