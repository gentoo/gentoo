# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A daemon to control laptop power consumption via cpufreq and disk standby"
HOMEPAGE="http://freecode.com/projects/cpudyn/"
SRC_URI="http://mnm.uib.es/~gallir/${PN}/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}/${PN}-0.99.0-init_conf_updates.patch"
)

src_prepare() {
	# fix #570082 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	default
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" cpudynd
}

src_install() {
	dosbin cpudynd

	doman cpudynd.8
	dodoc INSTALL README VERSION changelog
	dodoc *.html

	newinitd "${FILESDIR}"/cpudyn.init cpudyn
	newconfd debian/cpudyn.conf cpudyn
}

pkg_postinst() {
	einfo "Configuration file is /etc/conf.d/cpudyn."
}
