# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info systemd toolchain-funcs

COMMIT="1eedfbc9b318372efd119fd17f4abdbde561a53d"
S="${WORKDIR}/${PN}-${COMMIT}"

DESCRIPTION="inotify based cron daemon"
HOMEPAGE="https://incron.aiken.cz/"
SRC_URI="https://github.com/ar-/incron/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ~riscv x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.12-use-execl-instead-system.patch
	"${FILESDIR}"/${PN}-0.5.12-issue25.patch
)

DOCS=( CHANGELOG README TODO )

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
	# code is not C++17 ready
	append-cxxflags -std=c++14

	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr DOCDIR=/usr/share/doc/${PF} install
	einstalldocs

	newinitd "${FILESDIR}"/${PN}d-r1.init ${PN}d
	newconfd "${FILESDIR}"/${PN}d.conf ${PN}d
	systemd_dounit "${FILESDIR}"/${PN}d.service

	insinto /etc
	doins "${FILESDIR}"/${PN}.conf
	touch \
		"${ED}"/etc/${PN}.allow \
		"${ED}"/etc/${PN}.deny \
		|| die

	keepdir /etc/${PN}.d
	keepdir /var/spool/${PN}
}
