# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Extensible Python-based build utility"
HOMEPAGE="https://www.scons.org/"
SRC_URI="
	https://downloads.sourceforge.net/project/scons/scons/${PV}/${P}.tar.gz
	doc? (
		https://www.scons.org/doc/${PV}/PDF/${PN}-user.pdf -> ${P}-user.pdf
		https://www.scons.org/doc/${PV}/HTML/${PN}-user.html -> ${P}-user.html
	)
	test? ( https://github.com/scons/scons/archive/${PV}.tar.gz -> ${P}.gh.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-libs/libxml2[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

S=${WORKDIR}/${P}/src

PATCHES=(
	# support env passthrough for Gentoo ebuilds
	"${FILESDIR}"/scons-4.1.0-env-passthrough.patch
	# respect CC, CXX, C*FLAGS, LDFLAGS by default
	"${FILESDIR}"/scons-4.0.0-respect-cc-etc-r1.patch
)

src_unpack() {
	# use the git directory structure, but put pregenerated release
	# inside src/ subdirectory to make our life easier
	if use test; then
		unpack "${P}.gh.tar.gz"
	else
		mkdir -p "${P}"/src || die
	fi

	tar -C "${P}"/src --strip-components=1 -xzf "${DISTDIR}/${P}.tar.gz" || die
}

src_prepare() {
	# apply patches relatively to top directory
	cd "${WORKDIR}/${P}" || die
	distutils-r1_src_prepare

	# manpage install is completely broken
	sed -i -e '/build\/doc\/man/d' src/setup.cfg || die

	if use test; then
		local remove_tests=(
			# TODO: does not respect PATH?
			test/Clang
			# broken
			test/DVIPDF/DVIPDFFLAGS.py
			test/Java/swig-dependencies.py
			test/Java/multi-step.py
		)
		rm -r "${remove_tests[@]}" || die
	fi
}

python_test() {
	local -x COLUMNS=80
	# set variable from escons() of scons-util.eclass to make env-passthrough patch work within test env
	local -x GENTOO_SCONS_ENV_PASSTHROUGH=1
	# unset some env variables to pass appropriate tests
	unset AR AS ASFLAGS CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	cd "${WORKDIR}/${P}" || die
	"${EPYTHON}" runtest.py -a --passed \
		-j "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")"

	# runtest.py script returns "0" if all tests are passed
	# and returns "2" if there are any tests with "no result"
	# (i.e. in case if some tools are not installed or it's Windows specific tests)
	[[ ${?} == [02] ]] || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	doman *.1
	use doc && dodoc "${DISTDIR}"/${P}-user.{pdf,html}
}
