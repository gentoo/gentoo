# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils udev user

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code"
	inherit autotools git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm hppa ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd"
fi

DESCRIPTION="An implementation of Microsoft's Media Transfer Protocol (MTP)"
HOMEPAGE="http://libmtp.sourceforge.net/"

LICENSE="LGPL-2.1" # LGPL-2+ and LGPL-2.1+ ?
SLOT="0/9" # Based on SONAME of libmtp shared library
IUSE="+crypt doc examples static-libs"

RDEPEND="virtual/libusb:1
	crypt? ( >=dev-libs/libgcrypt-1.5.4:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	DOCS="AUTHORS README TODO"
	enewgroup plugdev
}

src_prepare() {
	# ChangeLog says "RETIRING THIS FILE ..pause..  GIT" (Last entry from start of 2011)
	rm -f ChangeLog

	if [[ ${PV} == 9999* ]]; then
		local crpthf=config.rpath
		local crpthd=/usr/share/gettext/${crpthf}
		if has_version '>sys-devel/gettext-0.18.3' && [[ -e ${crpthd} ]]; then
			cp "${crpthd}" .
		else
			touch ${crpthf} # This is from upstream autogen.sh
		fi
		eautoreconf
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable doc doxygen) \
		$(use_enable crypt mtpz) \
		--with-udev="$(get_udevdir)" \
		--with-udev-group=plugdev \
		--with-udev-mode=0660
}

src_install() {
	default
	prune_libtool_files --all

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,sh}
	fi
}
