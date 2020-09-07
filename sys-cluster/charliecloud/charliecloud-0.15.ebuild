# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools optfeature python-single-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hpc/${PN}.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/hpc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~x86-linux"
fi

DESCRIPTION="Lightweight user-defined software stacks for high-performance computing"
HOMEPAGE="https://hpc.github.io/charliecloud/"

SLOT="0"
LICENSE="Apache-2.0"
IUSE="ch-grow doc examples +pv +squashfs squashfuse"

# Extensive test suite exists, but downloads container images
# directly and via Docker and installs packages inside using apt/yum.
# Additionally, clashes with portage namespacing and sandbox.
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	pv? ( sys-apps/pv )
	squashfs? ( sys-fs/squashfs-tools )
	squashfuse? ( sys-fs/squashfuse )"
DEPEND="
	ch-grow? (
		$(python_gen_cond_dep '
			dev-python/lark-parser[${PYTHON_MULTI_USEDEP}]
			dev-python/requests[${PYTHON_MULTI_USEDEP}]
		')
	)
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_MULTI_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_MULTI_USEDEP}]
		')
		net-misc/rsync
	)"

src_prepare() {
	default
	sed -i 's/ -Werror//' configure.ac || die
	eautoreconf
}

src_configure() {
	local econf_args=()
	econf_args+=(
		$(use_enable doc html)
		$(use_enable ch-grow)
		# Libdir is used as a libexec-style destination.
		--libdir="${EPREFIX}"/usr/lib
		# Attempts to call python-exec directly otherwise.
		--with-sphinx-python=${PYTHON}
	)
	econf "${econf_args[@]}"
}

pkg_postinst() {
	elog "Various builders are supported, as alternative "
	elog "to the internal ch-grow. The following packages "
	elog "can be installed to get the corresponding support."

	optfeature "Building with Buildah" app-emulation/buildah
	optfeature "Building with Docker" app-emulation/docker
}
