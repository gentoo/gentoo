# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ORIG_PN="${PN%-scala}"

DESCRIPTION="Send XMPP (Jabber) messages via command line"
HOMEPAGE="https://github.com/flowdalic/sendxmpp"

if [[ "${PV}" == "9999" ]] || [[ -n "${EGIT_COMMIT_ID}" ]]; then
	EGIT_REPO_URI="https://github.com/Flowdalic/${ORIG_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/flowdalic/${ORIG_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${ORIG_PN}-${PV}"
fi

LICENSE="GPL-3+"

SLOT="0"

RDEPEND="
	dev-java/scala-cli-bin
	!net-im/sendxmpp
"

src_compile() {
	:
}

src_install() {
	default
	newbin sendxmpp.sc sendxmpp
}
