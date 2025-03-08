# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

COMMIT_ID="b9e779cd2e467c8e3122950f34dc08c84d6884e6"
HTTP_COMMIT="e7689c1b0535afab8c4ea95d2dea7906d8a3ef8d"
IDLE_COMMIT="8a8bbb76be64ad47893ca0d5648521c40bf9e956"
JS_COMMIT="781170a3ba4b2d083e8189d1ca36708c0dc8e9a9"
MEDIA_COMMIT="b0310b8e81ddc672856780f8d23eea2947a2a47b"
QT_REUSABLE_WIDGETS_COMMIT="197e8749fde2acd6f81e3a79c1d8db916611175f"
SHAREDCACHE_COMMIT="eec981a4285c7b371aa9dc7f0074f03794e86a26"
SINGLEAPPLICATION_COMMIT="494772e98cef0aa88124f154feb575cc60b08b38"

DESCRIPTION="Qt music player"
HOMEPAGE="https://flavio.tordini.org/musique"
SRC_URI="
	https://github.com/flaviotordini/${PN}/archive/${COMMIT_ID}.tar.gz \
		-> ${P}.tar.gz
	https://github.com/flaviotordini/http/archive/${HTTP_COMMIT}.tar.gz \
		-> ${PN}-http-${HTTP_COMMIT}.tar.gz
	https://github.com/flaviotordini/idle/archive/${IDLE_COMMIT}.tar.gz \
		-> ${PN}-idle-${IDLE_COMMIT}.tar.gz
	https://github.com/flaviotordini/js/archive/${JS_COMMIT}.tar.gz \
		-> ${PN}-js-${JS_COMMIT}.tar.gz
	https://github.com/flaviotordini/media/archive/${MEDIA_COMMIT}.tar.gz \
		-> ${PN}-media-${MEDIA_COMMIT}.tar.gz
	https://github.com/flaviotordini/qt-reusable-widgets/archive/${QT_REUSABLE_WIDGETS_COMMIT}.tar.gz \
		-> ${PN}-qt-reusable-widgets-${QT_REUSABLE_WIDGETS_COMMIT}.tar.gz
	https://github.com/flaviotordini/sharedcache/archive/${SHAREDCACHE_COMMIT}.tar.gz \
		-> ${PN}-sharedcache-${SHAREDCACHE_COMMIT}.tar.gz
	https://github.com/itay-grudev/SingleApplication/archive/${SINGLEAPPLICATION_COMMIT}.tar.gz \
		-> ${PN}-SingleApplication-${SINGLEAPPLICATION_COMMIT}.tar.gz
"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

# MIT for 3rdparty : http singleapplication
LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-qt/qtbase:6[dbus,gui,network,sqlite,widgets]
	dev-qt/qtdeclarative:6
	media-libs/taglib:=
	media-video/mpv:=[libmpv]
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( README.md )

src_prepare() {
	pushd "${S}"/lib || die
		local x
		for x in http idle js media qt-reusable-widgets sharedcache singleapplication updater; do
			rmdir ${x} || die
		done
		ln -s "${WORKDIR}/http-${HTTP_COMMIT}" http || die
		ln -s "${WORKDIR}/idle-${IDLE_COMMIT}" idle || die
		ln -s "${WORKDIR}/js-${JS_COMMIT}" js || die
		ln -s "${WORKDIR}/media-${MEDIA_COMMIT}" media || die
		ln -s "${WORKDIR}/qt-reusable-widgets-${QT_REUSABLE_WIDGETS_COMMIT}" qt-reusable-widgets || die
		ln -s "${WORKDIR}/sharedcache-${SHAREDCACHE_COMMIT}" sharedcache || die
		ln -s "${WORKDIR}/SingleApplication-${SINGLEAPPLICATION_COMMIT}" singleapplication || die
	popd || die

	sed -e 's:LASTFM_API_KEY = .*$:LASTFM_API_KEY = "";:' \
		-e 's:LASTFM_SHARED_SECRET = .*$:LASTFM_SHARED_SECRET = "";:' \
		-i src/constants.cpp || die

	default
}

src_configure() {
	eqmake6 ${PN}.pro PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
