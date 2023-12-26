# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 multiprocessing

MY_P="SCons-${PV}"
DESCRIPTION="Extensible Python-based build utility"
HOMEPAGE="
	https://www.scons.org/
	https://github.com/SCons/scons/
	https://pypi.org/project/SCons/
"
SRC_URI="
	https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${MY_P}.tar.gz
	doc? (
		https://www.scons.org/doc/${PV}/PDF/${PN}-user.pdf
			-> ${P}-user.pdf
		https://www.scons.org/doc/${PV}/HTML/${PN}-user.html
			-> ${P}-user.html
	)
	test? (
		https://github.com/SCons/scons/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

src_unpack() {
	# use the git directory structure, then unpack the pypi tarball
	# on top of it to make our life easier
	if use test; then
		unpack "${P}.gh.tar.gz"
	else
		mkdir -p "${P}" || die
	fi

	tar -C "${P}" --strip-components=1 --no-same-owner \
		-xzf "${DISTDIR}/${MY_P}.tar.gz" || die
}

src_prepare() {
	distutils-r1_src_prepare

	# TODO: rebase the patches <4.5.1-r2 is gone
	# support env passthrough for Gentoo ebuilds
	eapply -p2 "${FILESDIR}"/scons-4.1.0-env-passthrough.patch
	# respect CC, CXX, C*FLAGS, LDFLAGS by default
	eapply -p2 "${FILESDIR}"/scons-4.2.0-respect-cc-etc.patch

	if use test; then
		local remove_tests=(
			# TODO: does not respect PATH?
			test/Clang
			# broken
			test/DVIPDF/DVIPDFFLAGS.py
			test/Java/swig-dependencies.py
			test/Java/multi-step.py
			test/TEX/newglossary.py
			test/TEX/variant_dir_newglossary.py
			test/Configure/option--config.py
			# broken by commas in date, sic!
			test/option/option-v.py
			test/Interactive/version.py
			# warnings from new binutils?
			test/AS/as-live.py
			test/AS/nasm.py
			# hangs
			test/KeyboardInterrupt.py
			# requires f77 executable
			test/Fortran/F77PATH.py
			test/Fortran/FORTRANPATH.py
			test/Fortran/gfortran.py
			# TODO, these seem to be caused by our patches
			test/Repository/include.py
			test/Repository/multi-dir.py
			test/Repository/variants.py
			test/virtualenv/activated/option/ignore-virtualenv.py
			# broken by CC being set? *facepalm*
			test/LINK/applelink.py
			test/ToolSurrogate.py
			# no clue but why would we care about rpm?
			test/packaging/option--package-type.py
			test/packaging/rpm/cleanup.py
			test/packaging/rpm/internationalization.py
			test/packaging/rpm/multipackage.py
			test/packaging/rpm/package.py
			test/packaging/rpm/tagging.py
			# apparently fragile to... limits?
			# https://bugs.gentoo.org/908347#c7
			test/builderrors.py
		)

		if ! use amd64 && ! use x86 ; then
			# These tests are currently broken on arm and other non-amd64/x86 platforms
			# Work seems to be ongoing in e.g. https://github.com/SCons/scons/pull/4022 to
			# better plumb up the MSVC tests for alternative arches.
			# Try again after 4.2.0.
			# See also: https://pairlist4.pair.net/pipermail/scons-users/2020-November/008452.html
			# bug #757534
			remove_tests+=(
				test/MSVS/vs-7.0-scc-files.py
				test/MSVS/vs-7.0-scc-legacy-files.py
				test/MSVS/vs-7.1-scc-files.py
				test/MSVS/vs-7.1-scc-legacy-files.py
				test/MSVS/vs-scc-files.py
				test/MSVS/vs-scc-legacy-files.py
			)
		fi

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

	# sigh
	rm "${BUILD_DIR}/install/usr/bin/.sconsign" || die
}

python_install_all() {
	rm "${ED}"/usr/*.1 || die
	distutils-r1_python_install_all

	doman *.1
	use doc && dodoc "${DISTDIR}/${P}"-user.{pdf,html}
}
