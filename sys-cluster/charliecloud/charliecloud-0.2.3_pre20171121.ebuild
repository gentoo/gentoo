# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# User namespaces don't play well with the sandbox.
RESTRICT="test"

# Commit date: 21 Nov. 2017
COMMIT="3eb9e3edfbcd61257bb52a361cf01782fcf15b5d"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hpc/${PN}.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/hpc/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

DESCRIPTION="Lightweight user-defined software stacks for high-performance computing"
HOMEPAGE="https://hpc.github.io/charliecloud/"

SLOT="0"
LICENSE="Apache-2.0"
IUSE="doc examples suid test"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx
	       dev-python/sphinx_rtd_theme
	       net-misc/rsync )
	test? ( app-arch/pigz )"

src_compile() {
	if use suid; then
		export SETUID=1
	fi
	emake
	if use doc && ! use suid; then
		emake -C doc-src
	fi
}

src_install() {
	if use suid; then
		export SETUID=1
	fi
	emake install PREFIX="${EPREFIX}/usr" DESTDIR="${ED}"
	dodoc README.rst COPYRIGHT
	if use doc && ! use suid; then
		if ! use suid; then
			mv doc html || die
			dodoc -r html
		else
			ewarn "Building documentation with SUID not supported yet!"
		fi
	fi
	if use examples; then
		docompress -x "${EPREFIX}/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	rm -rf "${ED}/usr/share/doc/charliecloud" || die
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
