# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-single-r1

DESCRIPTION="C Library for manipulating Fedora Modularity metadata files"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
if [[ ${PV} = 9999* ]]; then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/fedora-modularity/libmodulemd.git"
else
		SRC_URI="https://github.com/fedora-modularity/libmodulemd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="amd64 ~arm64 x86"

		# Backports for tests
		SRC_URI+="
			https://github.com/fedora-modularity/libmodulemd/commit/89d4afb3d018250427d4d87840ae57aab3903361.patch
				-> ${PN}-2.15.2-glib-2.87.patch
			https://github.com/fedora-modularity/libmodulemd/commit/e33ecf1cc15383b9563bc4cd9a6908277bf8039d.patch
				-> ${PN}-2.15.2-pygobject-3.55.patch
		"
fi

LICENSE="MIT"
SLOT="0"

IUSE="doc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	app-arch/rpm
	sys-apps/file
	dev-libs/glib:2
	dev-libs/libyaml
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/gobject-introspection-1.82.0-r2
	dev-util/glib-utils
	doc? (
		dev-libs/glib[gtk-doc(+),doc(+)]
		dev-util/gtk-doc
	)
	test? (
		sys-libs/libmodulemd
	)
"

PATCHES=(
	"${DISTDIR}"/libmodulemd-2.15.2-glib-2.87.patch
	"${DISTDIR}"/libmodulemd-2.15.2-pygobject-3.55.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use doc with_docs)
	)
	meson_src_configure
}

src_test() {
	meson_src_test --no-suite ci_valgrind
}

src_install() {
	meson_src_install
	# We need to compile the gobject introspection overrides to prevent QA warnings
	local PYTHON_GI_OVERRIDESDIR=$("${EPYTHON}" -c 'import gi;print(gi._overridesdir)' || die)
	python_optimize "${D}${PYTHON_GI_OVERRIDESDIR}/"

}
