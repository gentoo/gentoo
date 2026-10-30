# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-utils-2

DESCRIPTION="Send XMPP (Jabber) messages via command line"
HOMEPAGE="https://github.com/flowdalic/sendxmpp"

if [[ "${PV}" == "9999" ]] || [[ -n "${EGIT_COMMIT_ID}" ]]; then
	EGIT_REPO_URI="https://github.com/Flowdalic/sendxmpp.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Flowdalic/sendxmpp/releases/download/${PV}/sendxmpp-dist-${PV}.jar"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}"
fi

LICENSE="GPL-3+"

SLOT="0"

RDEPEND="
	>=virtual/jre-17
	!net-im/sendxmpp
"

src_unpack() {
	# The distfile is the jar itself, nothing to unpack.
	:
}

src_install() {
	java-pkg_newjar "${DISTDIR}"/sendxmpp-dist-${PV}.jar sendxmpp.jar
	java-pkg_dolauncher sendxmpp -jar sendxmpp.jar

	insinto /var/lib/${PN}
	newins - version <<-EOF
	${PVR}
	EOF
}
