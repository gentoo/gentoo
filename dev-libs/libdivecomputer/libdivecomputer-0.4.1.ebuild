# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://libdivecomputer.git.sourceforge.net/gitroot/libdivecomputer/libdivecomputer"
	GIT_ECLASS="git-2"
	AUTOTOOLIZE=yes
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit eutils autotools-utils ${GIT_ECLASS}

if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
else
	SRC_URI="http://www.divesoftware.org/libdc/releases/${P}.tar.gz"
fi

DESCRIPTION="Library for communication with dive computers from various manufacturers"
HOMEPAGE="http://www.divesoftware.org/libdc"
LICENSE="LGPL-2.1"

SLOT="0"
IUSE="usb +static-libs -tools"

RDEPEND="usb? ( virtual/libusb:1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if [[ -n ${AUTOTOOLIZE} ]]; then
		autotools-utils_src_prepare
	else
		epatch_user
	fi
}

src_configure() {
	autotools-utils_src_configure

	if ! use tools ; then
		sed -i 's|examples||' Makefile || die "sed failed"
	fi
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	autotools-utils_src_install

	if use tools ; then
		einfo "prefixing tools with 'dctool_'"
		pushd "${D}/usr/bin/"
		for file in * ; do
			mv "${file}" "dctool_${file}" || die "prefixing tools failed"
		done
		popd
	fi
}

pkg_postinst() {
	if use tools ; then
		elog "The 'tools' USE flag has been enabled,"
		elog "to avoid file collisions, all ${PN}"
		elog "related tools have been prefixed with 'dctool_'"
	fi
}
