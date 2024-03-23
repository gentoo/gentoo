# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-r1

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/java-config.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="Java environment configuration query tool"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"

LICENSE="GPL-2"
SLOT="2"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="test? ( sys-apps/portage[${PYTHON_USEDEP}] )"

# baselayout-java is added as a dep till it can be added to eclass.
RDEPEND="
	${PYTHON_DEPS}
	sys-apps/baselayout-java
	sys-apps/portage[${PYTHON_USEDEP}]
"

src_configure() {
	local python_only=false
	python_foreach_impl my_src_configure
}

my_src_configure() {
	local emesonargs=(
		-Darch="${ARCH}"
		-Dpython-only="${python_only}"
		-Deprefix="${EPREFIX}"
	)

	meson_src_configure
	python_only=true
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	python_foreach_impl meson_src_test --no-rebuild --verbose
}

src_install() {
	python_foreach_impl my_src_install

	local scripts
	mapfile -t scripts < <(awk '/^#!.*python/ {print FILENAME} {nextfile}' "${ED}"/usr/bin/* || die)
	python_replicate_script "${scripts[@]}"

	# This replaces the file installed by java-config-wrapper.
	dosym java-config-2 /usr/bin/java-config
}

my_src_install() {
	meson_src_install

	local pydirs=(
		"${D}$(python_get_sitedir)"
	)
	python_optimize "${pydirs[@]}"
}
