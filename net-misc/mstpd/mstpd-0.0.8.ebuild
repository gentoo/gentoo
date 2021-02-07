# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 systemd

DESCRIPTION="Multiple spanning tree protocol daemon"
HOMEPAGE="https://github.com/mstpd/mstpd"
SRC_URI="https://github.com/mstpd/mstpd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	sed -i -e 's:-Werror::g' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--with-bashcompletiondir="$(get_bashcompdir)" \
		--localstatedir="${EPREFIX}"/var
}

src_install() {
	default

	# install systemd service
	systemd_dounit "${FILESDIR}"/${PN}.service

	gunzip "${ED}"/usr/share/man/man5/mstpctl-utils-interfaces.5.gz || die
	gunzip "${ED}"/usr/share/man/man8/mstpctl.8.gz || die
}
