# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# User namespaces don't play well with the sandbox.
RESTRICT="test"

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
IUSE="doc examples +pv test"

RDEPEND=""
DEPEND="${RDEPEND}
	pv? ( sys-apps/pv )
	doc? ( dev-python/sphinx
	       dev-python/sphinx_rtd_theme
	       net-misc/rsync )
	test? ( app-arch/pigz )"

DOCS=(
	README.rst
)

src_compile() {
	emake
	use doc && emake -C doc-src
}

src_install() {
	emake install PREFIX="${EPREFIX}/usr" DESTDIR="${ED}"
	if use doc; then
		mv doc html || die
		local HTML_DOCS=(html/.)
	fi
	if use examples; then
		docompress -x "${EPREFIX}/usr/share/doc/${PF}/examples"
		DOCS+=(examples)
	fi
	rm -rf "${ED}/usr/share/doc/charliecloud" || die
	einstalldocs
}

src_test() {
	cd "${S}/test" || die
	export CH_TEST_TARDIR="${T}/tarballs"
	export CH_TEST_IMGDIR="${T}/images"

	# Do not run tests requiring root.
	export CH_TEST_PERMDIRS="skip"
	export CH_TEST_SKIP_DOCKER=yes
	sed -i 's/CHTEST_HAVE_SUDO=yes/CHTEST_HAVE_SUDO=no/' "${S}/test/common.bash" || die

	emake test-quick
}
