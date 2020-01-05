# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hpc/${PN}.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/hpc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Lightweight user-defined software stacks for high-performance computing"
HOMEPAGE="https://hpc.github.io/charliecloud/"

SLOT="0"
LICENSE="Apache-2.0"
IUSE="doc examples +pv squashfuse"

# Extensive test suite exists, but downloads container images
# directly and via Docker and installs packages inside using apt/yum.
# Additionally, clashes with portage namespacing and sandbox.
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	pv? ( sys-apps/pv )
	squashfuse? ( sys-fs/squashfuse )
"
DEPEND="doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		net-misc/rsync
	)"

PATCHES=(
	# See upstream bug: https://github.com/hpc/charliecloud/pull/481/
	"${FILESDIR}"/"${PN}-${PV}"-fix-hardcoded-gcc.patch
)

src_compile() {
	emake
	use doc && emake -C doc-src
}

src_install() {
	emake install PREFIX="${EPREFIX}/usr" DESTDIR="${D}" DOCDIR="${ED}/usr/share/doc/${PF}" LIBEXEC_DIR="libexec/${PF}"
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	einstalldocs
}
