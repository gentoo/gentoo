# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 xdg

DESCRIPTION="Music player with a waveform progress bar (sound visualization like in audio editors)"
HOMEPAGE="https://nulloy.com"

EGIT_REPO_URI="https://github.com/nulloy/nulloy"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-3"
SLOT="0"
IUSE="+skins"

BDEPEND="dev-qt/linguist-tools"

DEPEND="
	dev-qt/qtcore
	dev-qt/designer
	dev-qt/linguist
	dev-qt/qtscript
	dev-qt/qtx11extras
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-plugins/gst-plugins-meta
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack

	if use skins ; then
		EGIT_REPO_URI=https://gitlab.com/vitaly-zdanevich/nulloy-theme-night.git
		EGIT_CHECKOUT_DIR=${WORKDIR}/night
		git-r3_src_unpack
	fi
}

src_prepare() {
	if use skins ; then
		default

		eapply "${FILESDIR}"/nulloy.patch
		cp -r $WORKDIR/night src/skins
	fi
}

src_configure() {
	# Upstream ./configure script does not support specifying an option's
	# value after an equal sign like in '--prefix="${EPREFIX}/usr"', so we
	# have to set up all the options ourselves and call the script directly
	local myconfargs=(
		$(use skins || echo --no-skins)
		--no-update-check
		--no-taglib
		--gstreamer-tagreader
		--prefix "${EPREFIX}/usr"
		--libdir "$(get_libdir)"
	)

	./configure "${myconfargs[@]}" || die
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
