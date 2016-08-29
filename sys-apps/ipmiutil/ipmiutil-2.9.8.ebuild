# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools systemd

DESCRIPTION="IPMI Management Utilities"
HOMEPAGE="http://ipmiutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND=">=dev-libs/openssl-1:0"
DEPEND="${RDEPEND}
	virtual/os-headers"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.8-flags.patch
)

src_prepare() {
	default

	sed -i -e 's|-O2 -g|$(CFLAGS)|g;s|-g -O2|$(CFLAGS)|g' util/Makefile.am* || die

	eautoreconf
}

src_configure() {
	econf --disable-systemd --enable-sha256
}

src_compile() {
	# Ulgy workaround. Upstream is misusing the make system here
	# and it doesn't even work.
	# Please check on each bump if this workaround is still required.
	pushd lib/lanplus &>/dev/null || die
	emake || die "emake lanplus failed"
	cp libipmi_lanplus.a .. || die
	popd &>/dev/null  || die

	emake
}

src_install() {
	emake DESTDIR="${D}" sysdto="${D}/$(systemd_get_systemunitdir)" install
	dodoc -r AUTHORS ChangeLog NEWS README TODO doc/UserGuide

	rm -r "${ED}"/etc/init.d || die 'remove initscripts failed' # These are only for Fedora
}
