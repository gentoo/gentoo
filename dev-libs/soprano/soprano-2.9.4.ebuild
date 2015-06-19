# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/soprano/soprano-2.9.4.ebuild,v 1.5 2013/12/11 20:31:20 ago Exp $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	git_eclass="git-2"
	EGIT_REPO_URI="git://anongit.kde.org/soprano"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi

inherit base cmake-utils flag-o-matic ${git_eclass}

DESCRIPTION="Library that provides a nice Qt interface to RDF storage solution"
HOMEPAGE="http://soprano.sourceforge.net"

LICENSE="LGPL-2"
SLOT="0"
IUSE="+dbus debug doc elibc_FreeBSD +raptor +redland test +virtuoso"

RESTRICT="test"
# bug 281712

COMMON_DEPEND="
	>=dev-qt/qtcore-4.5.0:4
	dbus? ( >=dev-qt/qtdbus-4.5.0:4 )
	raptor? ( >=media-libs/raptor-2.0.4:2 )
	redland? (
		>=dev-libs/rasqal-0.9.26
		>=dev-libs/redland-1.0.14
	)
	virtuoso? ( dev-db/libiodbc:0 )
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-qt/qttest-4.5.0:4 )
"
RDEPEND="${COMMON_DEPEND}
	virtuoso? ( >=dev-db/virtuoso-server-6.1.6 )
"

CMAKE_IN_SOURCE_BUILD="1"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.4-make-broken-redland-fatal.cmake"
)

pkg_setup() {
	if [[ ${PV} = *9999* && -z $I_KNOW_WHAT_I_AM_DOING ]]; then
		echo
		ewarn "WARNING! This is an experimental ebuild of ${PN} Git tree. Use at your own risk."
		ewarn "Do _NOT_ file bugs at bugs.gentoo.org because of this ebuild!"
		echo
	fi

	if ! use virtuoso; then
		echo
		ewarn "You have explicitly disabled the default soprano backend."
		ewarn "Applications using soprano may need at least one backend"
		ewarn "to be functional. If you experience any problems, enable"
		ewarn "the virtuoso USE flag."
		echo
	fi
}

src_configure() {
	# Fix for missing pthread.h linking
	# NOTE: temporarily fix until a better cmake files patch will be provided.
	use elibc_FreeBSD && append-flags -pthread

	local mycmakeargs=(
		-DSOPRANO_BUILD_TESTS=OFF
		-DCMAKE_SKIP_RPATH=OFF
		-DSOPRANO_DISABLE_SESAME2_BACKEND=ON
		-DSOPRANO_DISABLE_CLUCENE_INDEX=ON
		$(cmake-utils_use !dbus SOPRANO_DISABLE_DBUS)
		$(cmake-utils_use !raptor SOPRANO_DISABLE_RAPTOR_PARSER)
		$(cmake-utils_use !redland SOPRANO_DISABLE_RAPTOR_SERIALIZER)
		$(cmake-utils_use !redland SOPRANO_DISABLE_REDLAND_BACKEND)
		$(cmake-utils_use !virtuoso SOPRANO_DISABLE_VIRTUOSO_BACKEND)
		$(cmake-utils_use doc SOPRANO_BUILD_API_DOCS)
		$(cmake-utils_use test SOPRANO_BUILD_TESTS)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc AUTHORS ChangeLog README TODO
	newdoc backends/virtuoso/README README.virtuoso
	newdoc backends/sesame2/README README.sesame2
	if use doc ; then
		dohtml -r docs/html/
	fi
}
