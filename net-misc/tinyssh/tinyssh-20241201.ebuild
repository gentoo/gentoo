# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="A small SSH server with state-of-the-art cryptography"
HOMEPAGE="https://tinyssh.org"
if [[ "${PV}" == "99999999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/janmojzis/tinyssh.git"
else
	SRC_URI="https://github.com/janmojzis/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="CC0-1.0"
SLOT="0"

RDEPEND="
	${DEPEND}
	sys-apps/ucspi-tcp
"

src_prepare() {
	default

	echo 'gentoo-autoheaders: $(AUTOHEADERS)' >> Makefile || die
}

src_configure() {
	tc-export CC

	emake gentoo-autoheaders

	local i
	for i in has*.log
	do
		einfo "$i"
		cat "$i"
	done
}

src_install() {
	einstalldocs
	emake install DESTDIR="${D}" PREFIX=/usr

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"
	systemd_newunit "${FILESDIR}/${PN}.socket" "${PN}@.socket"
	systemd_dounit "${FILESDIR}/${PN}-makekey.service"
}

pkg_postinst() {
	einfo "TinySSH is in beta stage, and ready for production use."
	einfo "See https://tinyssh.org for more information."
}
