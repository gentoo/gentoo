# Copyright 2008-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit multiprocessing python-single-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://www.panda3d.org/download/${P}/${P}.tar.gz"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/panda3d/panda3d.git"
	EGIT_BRANCH="master"
fi

DESCRIPTION="A 3D game engine and framework for Python and C++."
HOMEPAGE="http://www.panda3d.org"

LICENSE="BSD"
SLOT="0"

IUSE="bullet +eigen ffmpeg fftw fmod jpeg opencv png +python +openal +ssl tiff truetype zlib"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	bullet? ( sci-physics/bullet )
	eigen? ( dev-cpp/eigen:3 )
	ffmpeg? ( media-video/ffmpeg:0= )
	fmod? ( media-libs/fmod:1 )
	jpeg? ( virtual/jpeg:0 )
	opencv? ( media-libs/opencv:0= )
	png? ( media-libs/libpng:0= )
	${PYTHON_DEPS}
	openal? ( media-libs/openal )
	ssl? ( dev-libs/openssl:0= )
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype )
	zlib? ( sys-libs/zlib )
	virtual/opengl"
RDEPEND="${DEPEND}"
# libav might work instead of ffmpeg, but is not recommended/untested upstream.

src_compile() {
	"${EPYTHON}" makepanda/makepanda.py \
		--everything \
		--$(usex bullet use)-bullet \
		--$(usex eigen use)-eigen \
		--$(usex ffmpeg use)-ffmpeg \
		--$(usex fftw use)-fftw \
		--$(usex fmod use)-fmod \
		--$(usex jpeg use)-jpeg \
		--$(usex png use)-png \
		--$(usex opencv use)-opencv \
		--$(usex python use)-python \
		--$(usex openal use)-openal \
		--$(usex ssl use)-openssl \
		--$(usex tiff use)-tiff \
		--$(usex truetype use)-freetype \
		--$(usex zlib use)-zlib \
		--no-fcollada \
		--no-gles \
		--no-gles2 \
		--no-ode \
		--no-rocket \
		--no-squish \
		--no-vrpn \
		--threads $(makeopts_jobs) \
		|| die "build failed"

		# The X11/OpenGL stuff and a USE flag could be added.
		# For such builds drop the --everything
}

src_install() {
	"${EPYTHON}" makepanda/installpanda.py --destdir "${D}" --prefix "${EPREFIX}/usr" || die "install failed"
}
