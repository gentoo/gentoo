# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ORIG_PN="${PN%-amm}"

DESCRIPTION="Send XMPP (Jabber) messages via command line"
HOMEPAGE="https://github.com/flowdalic/sendxmpp"

if [[ "${PV}" == "9999" ]] || [[ -n "${EGIT_COMMIT_ID}" ]]; then
	EGIT_REPO_URI="https://github.com/Flowdalic/${ORIG_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/flowdalic/${ORIG_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${ORIG_PN}-${PV}"
fi

LICENSE="GPL-3+"

SLOT="0"

RDEPEND="
	dev-lang/ammonite-repl-bin[scala2-13]
	!net-im/sendxmpp
"

src_prepare() {
	default
	# Ensure that the script is using the right Scala version.
	sed -i '1 s;^.*$;#!/usr/bin/env amm-2.13;' sendxmpp || die
}

src_compile() {
	:
}

src_install() {
	default
	dobin sendxmpp
}
