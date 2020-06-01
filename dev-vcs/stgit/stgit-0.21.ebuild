# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Manage a stack of patches using GIT as a backend"
HOMEPAGE="http://www.procode.org/stgit/"
UPSTREAM_VER=
[[ -n ${UPSTREAM_VER} ]] && \
	UPSTREAM_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${P}-upstream-patches-${UPSTREAM_VER}.tar.xz"

SRC_URI="https://github.com/ctmarinas/stgit/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${UPSTREAM_PATCHSET_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=">=dev-vcs/git-1.6.3.3"

# NOTE: It seems to be quite important which asciidoc version to use.
# So keep an eye on it for the future.
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		app-text/xmlto
		dev-lang/perl
	)"

PATCHES=(
	"${FILESDIR}/${PN}-0.16-man-linkfix.patch"
)

pkg_setup() {
	if ! use doc; then
		echo
		ewarn "Manpages will not be built and installed."
		ewarn "Enable the 'doc' useflag, if you want them."
		echo
	fi
}

python_prepare_all() {
	# Upstream's patchset
	[[ -n ${UPSTREAM_VER} ]] && \
		eapply "${WORKDIR}"/patches-upstream

	# this will be a noop, as we are working with a tarball,
	# but throws git errors --> just get rid of it
	echo "version=\"${PV}\"" > "${S}"/stgit/builtin_version.py

	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile

	# bug 526468
	if use doc; then
		emake DESTDIR="${D}" \
			htmldir="${EPREFIX}/usr/share/doc/${PF}/html/" \
			mandir="${EPREFIX}/usr/share/man/" \
			doc
	fi
}

src_install() {
	if use doc; then
		emake DESTDIR="${D}" \
			htmldir="${EPREFIX}/usr/share/doc/${PF}/html/" \
			mandir="${EPREFIX}/usr/share/man/" \
			install-doc install-html
	fi

	distutils-r1_src_install

	newbashcomp completion/stgit.bash 'stg'
}
