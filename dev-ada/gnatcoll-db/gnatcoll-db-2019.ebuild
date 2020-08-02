# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
ADA_COMPAT=( gnat_201{6,7,8,9} )
inherit ada multilib multiprocessing autotools python-single-r1

commitId="fbc46346dc67dfa83ae5132ef72fdd64fbe7e199"
DESCRIPTION="GNAT Component Collection"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="https://github.com/AdaCore/${PN}/archive/${commitId}.tar.gz
	-> ${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="db2ada gnatinspect postgres
	+shared sql sqlite static-libs static-pic xref"

RDEPEND="dev-ada/gnatcoll-core[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	sqlite? ( dev-db/sqlite:3 )
	postgres? ( dev-db/postgresql:* )
	xref? (
		dev-ada/gnatcoll-bindings[${ADA_USEDEP},iconv,shared?,static-libs?,static-pic?]
	)
	${ADA_DEPS}
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="gnatinspect? ( xref )
	xref? ( sqlite )
	sqlite? ( sql )
	db2ada? ( sql )
	${ADA_REQUIRED_USE}
	${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"/${PN}-${commitId}

PATCHES=( "${FILESDIR}"/${PN}-2018-gentoo.patch )

pkg_setup() {
	python-single-r1_pkg_setup
	ada_setup
}

src_compile() {
	build () {
		GPR_PROJECT_PATH="${S}/sql":"${S}/sqlite":"${S}/xref" \
			gprbuild -p -m -v -j$(makeopts_jobs) -XGNATCOLL_SQLITE=external \
			-XGNATCOLL_VERSION=2018 \
			-XBUILD=PROD -XLIBRARY_TYPE=$2 -XXMLADA_BUILD=$2 -XGPR_BUILD=$2 \
			-P $1/$3.gpr \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die "gprbuild failed"
	}
	local lib
	for kind in shared static-libs static-pic ; do
		if use $kind; then
			lib=${kind%-libs}
			lib=${lib/shared/relocatable}
			for dir in sql sqlite xref postgres ; do
				if use $dir; then
					build $dir $lib gnatcoll_${dir}
				fi
			done
		fi
	done
	if use shared; then
		lib=relocatable
	elif use static-libs; then
		lib=static
	else
		lib=static-pic
	fi
	if use gnatinspect; then
		build gnatinspect ${lib} gnatinspect
	fi
	if use db2ada; then
		build gnatcoll_db2ada ${lib} gnatcoll_db2ada
	fi
}

src_install() {
	build () {
		GPR_PROJECT_PATH="${D}/usr/share/gpr" gprinstall -p -f \
			-XBUILD=PROD -XGNATCOLL_VERSION=2018 \
			--prefix="${D}"/usr -XLIBRARY_TYPE=$2 -XXMLADA_BUILD=$2 \
			-XGPR_BUILD=$2 --build-name=$2 --build-var=LIBRARY_TYPE \
			-P $1/$3.gpr
	}
	local lib
	for kind in shared static-libs static-pic ; do
		if use $kind; then
			lib=${kind%-libs}
			lib=${lib/shared/relocatable}
			for dir in sql sqlite xref postgres ; do
				if use $dir; then
					build $dir $lib gnatcoll_${dir}
				fi
			done
		fi
	done
	if use shared; then
		lib=relocatable
	elif use static-libs; then
		lib=static
	else
		lib=static-pic
	fi
	if use gnatinspect; then
		build gnatinspect ${lib} gnatinspect
	fi
	if use db2ada; then
		build gnatcoll_db2ada ${lib} gnatcoll_db2ada
	fi
	rm -rf "${D}"/usr/share/gpr/manifests
	einstalldocs
}
