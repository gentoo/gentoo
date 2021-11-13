# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop optfeature python-single-r1

MY_P="${PN}-$(ver_cut 1-3)"

DESCRIPTION="Enriched clone of the game 'Logical' by Rainbow Arts"
HOMEPAGE="https://pathological.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/pathological/${MY_P}.tar.gz
	mirror://debian/pool/main/p/pathological/${MY_P/-/_}-${PV/*_p}.debian.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	media-libs/sdl2-image[jpeg,png]
	$(python_gen_cond_dep 'dev-python/pygame[${PYTHON_USEDEP}]')"
BDEPEND="
	${PYTHON_DEPS}
	doc? ( media-libs/netpbm[png] )"

PATCHES=(
	"${FILESDIR}"/${P}-pygame2-compat.patch
)

src_prepare() {
	# debian's patches add python3 support and sanitize other aspects
	# use_ogg_music: excluded given .xm files are fine
	local debian=($(<"${WORKDIR}"/debian/patches/series))
	debian=(${debian[@]/60_use_ogg_music.patch/})
	PATCHES+=("${debian[@]/#/${WORKDIR}/debian/patches/}")

	default

	sed -e "s|^cd .*/|cd ${EPREFIX}/usr/share/|" \
		-e "s|^exec|exec ${EPYTHON}|" \
		-i ${PN} || die

	gzip -d ${PN}.6.gz || die
	rm graphics/*.xcf || die
}

src_compile() {
	use doc && emake docs
}

src_install() {
	dobin ${PN}
	doman ${PN}.6

	insinto /usr/share/${PN}
	doins -r circuits graphics music sounds ${PN}.py

	doicon ${PN}.xpm
	domenu "${WORKDIR}"/debian/${PN}.desktop

	use doc && local HTML_DOCS=( html/. )
	dodoc changelog
	einstalldocs
}

pkg_postinst() {
	optfeature "background music support" "media-libs/sdl2-mixer[mod]"
}
