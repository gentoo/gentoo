# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# There are no new releases for old data files but the archival repo can update
# the accompanying documentation [but this ebuild only cares for the data ;) ].
COMMIT=700c7c1775da12f630750cc34149763ee52aa6c6

DESCRIPTION="The Fluid R3 version 1 soundfont"
HOMEPAGE="https://github.com/pinkflames/fluid-soundfont"
SRC_URI="
	https://github.com/pinkflames/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+gm gs"

BDEPEND="media-libs/flac"

REQUIRED_USE="|| ( gm gs )"

DOCS=( original/COPYING original/README )

S="${WORKDIR}"/${PN}-${COMMIT}

src_prepare() {
	default

	einfo "Using the flac tool to decompress the soundfont(s):"
	if use gm; then
		flac --force-raw-format --endian=little --sign=signed -d original/FluidR3_GM.sf2.flacy -o FluidR3_GM.sf2 || die
	fi
	if use gs; then
		flac --force-raw-format --endian=little --sign=signed -d original/FluidR3_GS.sf2.flacy -o FluidR3_GS.sf2 || die
	fi
}

src_install() {
	default

	insinto /usr/share/sounds/sf2
	use gm && doins FluidR3_GM.sf2
	use gs && doins FluidR3_GS.sf2

	if use gm; then
		# Since  enabling is done via eselect timidity, it's safe to always install our patchset
		insinto /usr/share/timidity/${PN}
		doins contrib/timidity.cfg
	fi
}

pkg_postinst() {
	elog "Music produced from samples under MIT licence may itself be subject to"
	elog "it, if the samples constitute a substantial portion of the work. In" 
	elog "particular this means reproducing the copyright notice and the licence"
	elog "when distributing derived works. This is not legal advice."
	if ! use gm; then
		elog
		ewarn "By user choice only the GS set is being installed - it contains SFX"
		ewarn "sounds in banks >0 but lacks musical instruments found in bank 0!"
		ewarn "To play MIDI music, re-install with the gm USE enabled."
	fi
}
