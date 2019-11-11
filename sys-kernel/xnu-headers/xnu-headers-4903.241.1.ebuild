# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="System headers provided by XNU-${PV}, macOS 10.14.3"
HOMEPAGE="https://opensource.apple.com/source/xnu"
SRC_URI="https://opensource.apple.com/tarballs/xnu/xnu-${PV}.tar.gz"

LICENSE="APSL-2"
SLOT="10.14"
KEYWORDS="~x64-macos"
IUSE="+man"

S=${WORKDIR}/xnu-${PV}

src_compile() {
	: ; # nothing to compile
}

src_install() {
	insinto /usr/include
	doins EXTERNAL_HEADERS/AssertMacros.h EXTERNAL_HEADERS/Availability*.h

	cd bsd || die

	get_datafiles() {
		local f="$1"/Makefile
		sed -n -e '/^DATAFILES \?=/,/^$/p' "${f}" \
			| sed -e '1s/^DATAFILES \?=//' -e '/\s*#/d' \
			| sed -e 's/\\$//'
	}

	local d
	local files
	for d in arm i386 machine miscfs/{devfs,specfs,union} net \
		netinet{,6} netkey nfs sys{,/_types} uuid vfs ; do
		insinto /usr/include/${d}
		files=( $(get_datafiles ${d}) )
		einfo "${d}:" ${files[*]}
		doins ${files[@]/#/$d/}
	done

	use man && doman man/man*/*.[234579]
}
