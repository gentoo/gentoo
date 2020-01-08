# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info systemd toolchain-funcs

COMMIT="1eedfbc9b318372efd119fd17f4abdbde561a53d"
S="${WORKDIR}/${PN}-${COMMIT}"

DESCRIPTION="inotify based cron daemon"
HOMEPAGE="https://incron.aiken.cz/"
SRC_URI="https://github.com/ar-/incron/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-0.5.12-use-execl-instead-system.patch )

# < 2.6.18 => INOTIFY, >= 2.6.18 => INOTIFY_USER
# It should be ok to expect at least 2.6.18
CONFIG_CHECK="~INOTIFY_USER"

src_prepare() {
	default

	sed -i \
		-e '/$(INSTALL) -m 0644 incron.conf $(DESTDIR)$(INITDIR)/d' \
		Makefile \
		|| die
}

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr DOCDIR=/usr/share/doc/${PF} install

	newinitd "${FILESDIR}/incrond-r1.init" incrond
	newconfd "${FILESDIR}/incrond.conf" incrond
	systemd_dounit "${FILESDIR}/incrond.service"

	dodoc CHANGELOG README TODO

	insinto /etc
	doins "${FILESDIR}"/incron.conf
	touch \
		"${D}/etc/incron.allow" \
		"${D}/etc/incron.deny" \
		|| die

	keepdir /var/spool/${PN}
}
