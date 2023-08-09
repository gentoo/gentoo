# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

IUSE="+sodium"

DEPEND="
	sodium? ( dev-libs/libsodium:= )
"
RDEPEND="
	${DEPEND}
	sys-apps/ucspi-tcp
"

src_prepare() {
	# Leave optimization level to user CFLAGS
	sed -i 's/-Os -fomit-frame-pointer -funroll-loops//g' ./conf-cc || die

	# Use make-tinysshcc.sh script, which has no tests and doesn't execute
	# binaries. See https://github.com/janmojzis/tinyssh/issues/2
	sed -i 's/make-tinyssh\.sh/make-tinysshcc.sh/g' ./Makefile || die

	default
}

src_compile() {
	tc-export PKG_CONFIG

	if use sodium
	then
		emake \
			CC="$(tc-getCC)" \
			LIBS="$("${PKG_CONFIG}" --libs libsodium)" \
			CFLAGS="${CFLAGS} $("${PKG_CONFIG}" --cflags libsodium)" \
			LDFLAGS="${LDFLAGS}"
	else
		emake CC="$(tc-getCC)"
	fi
}

src_install() {
	dosbin build/bin/tinysshd{,-makekey}
	dobin build/bin/tinysshd-printkey
	doman man/*

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
