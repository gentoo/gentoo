# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils readme.gentoo systemd toolchain-funcs

MY_P=${P/-updater/}
DESCRIPTION="no-ip.com dynamic DNS updater"
HOMEPAGE="http://www.no-ip.com"
SRC_URI="http://www.no-ip.com/client/linux/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gcc"

S=${WORKDIR}/${MY_P}

DOC_CONTENTS="
	Configuration can be done manually via /usr/sbin/noip2 -C or
	by using this ebuild's config option.
"

src_prepare() {
	epatch "${FILESDIR}"/noip-2.1.9-flags.patch
	epatch "${FILESDIR}"/noip-2.1.9-daemon.patch
	sed -i \
		-e "s:\(#define CONFIG_FILEPATH\).*:\1 \"/etc\":" \
		-e "s:\(#define CONFIG_FILENAME\).*:\1 \"/etc/no-ip2.conf\":" \
		noip2.c || die "sed failed"
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		PREFIX=/usr \
		CONFDIR=/etc
}

src_install() {
	dosbin noip2
	dodoc README.FIRST
	newinitd "${FILESDIR}"/noip2.start noip
	systemd_dounit "${FILESDIR}"/noip.service
	readme.gentoo_create_doc
}

pkg_config() {
	cd /tmp
	einfo "Answer the following questions."
	noip2 -C || die
}
