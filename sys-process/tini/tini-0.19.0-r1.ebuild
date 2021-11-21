# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

# guard against forgetfulness, https://bugs.gentoo.org/795936
GIT_COMMIT_0190="de40ad007797e0dcd8b7126f27bb87401d224240"
GIT_COMMIT="GIT_COMMIT_${PV//./}"
GIT_COMMIT="${!GIT_COMMIT}"

DESCRIPTION="A tiny but valid init for containers"
HOMEPAGE="https://github.com/krallin/tini"
SRC_URI="https://github.com/krallin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv ~x86"
IUSE="+args +static"

src_prepare() {

	[[ -z ${GIT_COMMIT} ]] && die "forgetful maintainer! please define GIT_COMMIT_${PV//./} on bump"

	cmake_src_prepare

	local sed_args=(
		# Do not strip binary
		-e 's/-Wl,-s")$/")/'

		# Remove -Werror and -pedantic-errors in order to allow macro
		# redefinition, so that CFLAGS="-U_FORTIFY_SOURCE" does not
		# trigger an error due to add_definitions(-D_FORTIFY_SOURCE=2)
		# in CMakeLists.txt (bug 626438).
		-e "s/ -Werror / /"
		-e "s/ -pedantic-errors / /"
	)

	sed -i "${sed_args[@]}" \
		-e "s/git.*status --porcelain.*/true/" \
		-e "s/git.*log -n 1.*/true/" \
		-e "s/git.\${tini_VERSION_GIT}/git.${GIT_COMMIT}/" \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=()
	use args || mycmakeargs+=(-DMINIMAL=ON)

	cmake_src_configure
}

src_compile() {
	append-cflags -DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37
	cmake_src_compile
}

src_install() {
	cmake_src_install
	if use static; then
		mv "${ED}"/usr/bin/{${PN}-static,${PN}} || die
	else
		rm "${ED}"/usr/bin/${PN}-static || die
	fi
}
