# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_IN_SOURCE_BUILD=1
WX_GTK_VER="3.0"

inherit cmake-utils user wxwidgets

MY_PN=${PN/a/A}

KEYWORDS="amd64 x86"

DESCRIPTION="${MY_PN} is a job scheduler for PostgreSQL"
HOMEPAGE="http://www.pgadmin.org/download/pgagent.php"
SRC_URI="mirror://postgresql/pgadmin3/release/${PN}/${MY_PN}-${PV}-Source.tar.gz"
LICENSE="POSTGRESQL GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-db/postgresql:*
		 x11-libs/wxGTK:${WX_GTK_VER}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}-Source"

PATCHES=(
	"${FILESDIR}/fix-dbconn-getlasterror-crash.patch"
	"${FILESDIR}/save-stderr-jobstep-output.patch"
	"${FILESDIR}/add-log-timestamps.patch"
	"${FILESDIR}/fix-job-success-test.patch"
	"${FILESDIR}/postgres-10-build-fix.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s:share):share/${P}):" \
		-i CMakeLists.txt || die "failed to patch CMakeLists.txt"
	sed -i -e '/SET(WX_VERSION "2.8")/d' CMakeLists.txt || die
}

src_configure() {
	if has_version "x11-libs/wxGTK[X]"; then
		need-wxwidgets unicode
	else
		need-wxwidgets base-unicode
	fi
	mycmakeargs=( "-DSTATIC_BUILD:BOOLEAN=FALSE"
				  "-DWX_VERSION=${WX_GTK_VER}" )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}/pgagent.initd-r1" "${PN}"
	newconfd "${FILESDIR}/pgagent.confd" "${PN}"

	rm "${ED}"/usr/{LICENSE,README} || die "failed to remove useless docs"
}

pkg_preinst() {
	# This user needs a real shell, and the daemon will use the
	# ~/.pgpass file from its home directory.
	enewuser pgagent -1 /bin/bash /home/pgagent
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		# This warning can be removed around a year after this version
		# goes stable.
		ewarn 'pgAgent now runs as a dedicated "pgagent" user (as'
		ewarn 'opposed to root). You may need to move your /root/.pgpass'
		ewarn 'file to /home/pgagent/.pgpass, and the new user will'
		ewarn 'need permissions on any paths that it will access.'
	fi
}
