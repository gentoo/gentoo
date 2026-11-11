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
	KEYWORDS="amd64 arm64"
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
	# scallop and os-lib are compiled with Scala < 3.8, whose lazy vals use
	# sun.misc.Unsafe, which causes a warning on JDK 24+. Use the system
	# property instead of --sun-misc-unsafe-memory-access=allow, since it is
	# ignored by older JDKs.
	java-pkg_dolauncher sendxmpp \
		--java_args -Dsun.misc.unsafe.memory.access=allow \
		-jar sendxmpp.jar

	insinto /var/lib/${PN}
	newins - version <<-EOF
	${PVR}
	EOF
}
