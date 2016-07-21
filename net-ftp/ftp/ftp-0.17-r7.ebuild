# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

PATCHLEVEL=1

inherit eutils toolchain-funcs flag-o-matic

MY_P=netkit-${P}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Standard Linux FTP client"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="ssl ipv6"

RDEPEND=">=sys-libs/ncurses-5.2
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_DIR="${WORKDIR}"/patch \
		EPATCH_SUFFIX="patch" \
		epatch
	append-lfs-flags #101038
}

src_compile() {
	./configure \
		--prefix=/usr \
		$(use_enable ssl) \
		$(use_enable ipv6) \
		${EXTRA_ECONF} \
		|| die "configure failed"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" || die "make failed"
}

src_install() {
	dobin ftp/ftp || die
	doman ftp/ftp.1 ftp/netrc.5
	dodoc ChangeLog README BUGS
}
