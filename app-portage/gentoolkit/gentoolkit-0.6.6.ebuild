# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="xml(+),threads(+)"

inherit meson python-r1 tmpfiles

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoolkit.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/gentoolkit.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage-Tools"

LICENSE="GPL-2"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="test"
RESTRICT="!test? ( test )"

# Need newer Portage for eclean-pkg API, bug #900224
DEPEND="
	>=sys-apps/portage-3.0.57[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	app-alternatives/awk
	sys-apps/gentoo-functions
"

# setuptools is still needed as a workaround for Python 3.12+ for now.
# https://github.com/mesonbuild/meson/issues/7702
#
# >=meson-1.2.1-r1 for bug #912051
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-1.2.1-r1
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' python3_12)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	default
	if use prefix-guest ; then
		# use correct repo name, bug #632223
		sed -i \
			-e "/load_profile_data/s/repo='gentoo'/repo='gentoo_prefix'/" \
			pym/gentoolkit/profile.py || die
	fi
}

src_configure() {
	local code_only=false
	python_foreach_impl my_src_configure
}

my_src_configure() {
	local emesonargs=(
		-Dcode-only=${code_only}
		$(meson_use test tests)
		-Deprefix="${EPREFIX}"
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
	)

	meson_src_configure
	code_only=true
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	python_foreach_impl meson_src_test --no-rebuild --verbose
}

src_install() {
	python_foreach_impl my_src_install
	dotmpfiles data/tmpfiles.d/revdep-rebuild.conf

	local scripts
	mapfile -t scripts < <(awk '/^#!.*python/ {print FILENAME} {nextfile}' "${ED}"/usr/bin/* || die)
	python_replicate_script "${scripts[@]}"
}

my_src_install() {
	local pydirs=(
		"${D}$(python_get_sitedir)"
	)

	meson_src_install
	python_fix_shebang "${pydirs[@]}"
	python_optimize "${pydirs[@]}"
}

pkg_postinst() {
	tmpfiles_process revdep-rebuild.conf

	# Only show the elog information on a new install
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog
		elog "For further information on gentoolkit, please read the gentoolkit"
		elog "guide: https://wiki.gentoo.org/wiki/Gentoolkit"
		elog
		elog "Another alternative to equery is app-portage/portage-utils"
		elog
		elog "Additional tools that may be of interest:"
		elog
		elog "    app-admin/eclean-kernel"
		elog "    app-portage/diffmask"
		elog "    app-portage/flaggie"
		elog "    app-portage/portpeek"
		elog "    app-portage/smart-live-rebuild"
	fi
}
