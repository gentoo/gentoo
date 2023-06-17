# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs

DESCRIPTION="small audio and MIDI framework part of the OpenBSD project"
HOMEPAGE="http://www.sndio.org/"
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://caoua.org/git/sndio"
	EGIT_MIN_CLONE_TYPE="single+tags"
else
	SRC_URI="http://www.sndio.org/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="ISC"
SLOT="0/7.1"
IUSE="alsa"

DEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	acct-user/sndiod
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	tc-export CC

	# Not autotools-based but a custom one.
	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--privsep-user=sndiod \
		--with-libbsd \
		$(use_enable alsa) \
	|| die "Configure failed"
}

src_install() {
	multilib-minimal_src_install

	doinitd "${FILESDIR}/sndiod"
}
