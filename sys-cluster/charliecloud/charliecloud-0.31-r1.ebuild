# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

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
IUSE="ch-image doc"

# Extensive test suite exists, but downloads container images
# directly and via Docker and installs packages inside using apt/yum.
# Additionally, clashes with portage namespacing and sandbox.
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	elibc_musl? ( sys-libs/argp-standalone )
"
DEPEND="
	ch-image? (
		$(python_gen_cond_dep '
			dev-python/lark[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
		')
	)
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
		net-misc/rsync
	)"

PATCHES=(
	"${FILESDIR}"/${P}-realpath_return.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local econf_args=()
	econf_args+=(
		$(use_enable doc html)
		$(use_enable ch-image)
		# Libdir is used as a libexec-style destination.
		--libdir="${EPREFIX}"/usr/lib
		# Attempts to call python-exec directly otherwise.
		--with-sphinx-python="${EPYTHON}"
		# This disables -Werror, see also: https://github.com/hpc/charliecloud/pull/808
		--enable-buggy-build
		# Do not use bundled version of dev-python/lark.
		--disable-bundled-lark
		# Use correct shebang.
		--with-python="${PYTHON}"
	)
	econf "${econf_args[@]}"
}

src_install() {
	docompress -x "${EPREFIX}"/usr/share/doc/"${PF}"/examples
	default
}

pkg_postinst() {
	elog "Various builders are supported, as alternative to the internal ch-image."
	optfeature "Building with Buildah" app-containers/buildah
	optfeature "Building with Docker" app-containers/docker
	optfeature "Progress bars during long operations" sys-apps/pv
	optfeature "Pack and unpack squashfs images" sys-fs/squashfs-tools
	optfeature "Mount and umount squashfs images" sys-fs/squashfuse
	optfeature "Build versioning with ch-image" dev-vcs/git
}
