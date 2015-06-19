# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ccpn/ccpn-2.4.2_p150421.ebuild,v 1.1 2015/04/21 13:00:03 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl,tk"

inherit eutils flag-o-matic multilib portability python-single-r1 toolchain-funcs versionator

PATCHSET="${PV##*_p}"
MY_PN="${PN}mr"
MY_PV="$(replace_version_separator 3 _ ${PV%%_p*})"
MY_MAJOR="$(get_version_component_range 1-3)"

DESCRIPTION="The Collaborative Computing Project for NMR"
HOMEPAGE="http://www.ccpn.ac.uk/ccpn"
SRC_URI="http://www-old.ccpn.ac.uk/download/${MY_PN}/analysis${MY_PV}.tar.gz"
[[ -n ${PATCHSET} ]] \
	&& SRC_URI+=" http://dev.gentoo.org/~jlec/distfiles/ccpn-update-${MY_MAJOR}-${PATCHSET}.patch.xz"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+opengl"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-lang/tk:0=[threads]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-tcltk/tix
	=sci-libs/ccpn-data-"${MY_MAJOR}"*[${PYTHON_USEDEP}]
	sci-biology/psipred
	x11-libs/libXext
	x11-libs/libX11
	opengl? (
		media-libs/freeglut
		dev-python/pyglet[${PYTHON_USEDEP}]
		)"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}/${MY_PN}$(get_version_component_range 1-2)

src_prepare() {
	[[ -n ${PATCHSET} ]] && \
		EPATCH_OPTS="-p2" epatch "${WORKDIR}"/ccpn-update-${MY_MAJOR}-${PATCHSET}.patch

	epatch "${FILESDIR}"/2.3.1-parallel.patch

	append-lfs-flags

	sed \
		-e "/PSIPRED_DIR/s:'data':'share/psipred/data':g" \
		-e "s:weights_s:weights:g" \
		-i python/ccpnmr/analysis/wrappers/Psipred.py || die

	local tk_ver
	local myconf

	tk_ver="$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)"

	if use opengl; then
		GLUT_NEED_INIT="-DNEED_GLUT_INIT"
		IGNORE_GL_FLAG=""
		GL_FLAG="-DUSE_GL_TRUE"
		GL_DIR="${EPREFIX}/usr"
		GL_LIB="-lglut -lGLU -lGL"
		GL_INCLUDE_FLAGS="-I\$(GL_DIR)/include"
		GL_LIB_FLAGS=""
	else
		IGNORE_GL_FLAG="-DIGNORE_GL"
		GL_FLAG="-DUSE_GL_FALSE"
	fi

	GLUT_NOT_IN_GL=""
	GLUT_FLAG="\$(GLUT_NEED_INIT) \$(GLUT_NOT_IN_GL)"

	rm -rf data model doc license || die

	sed \
		-e "s|/usr|${EPREFIX}/usr|g" \
		-e "s|^\(CC =\).*|\1 $(tc-getCC)|g" \
		-e "s|^\(OPT_FLAG =\).*|\1 ${CPPFLAGS} ${CFLAGS}|g" \
		-e "s|^\(LINK_FLAGS =.*\)|\1 ${LDFLAGS}|g" \
		-e "s|^\(IGNORE_GL_FLAG =\).*|\1 ${IGNORE_GL_FLAG}|g" \
		-e "s|^\(GL_FLAG =\).*|\1 ${GL_FLAG}|g" \
		-e "s|^\(GL_DIR =\).*|\1 ${GL_DIR}|g" \
		-e "s|^\(GL_LIB =\).*|\1 ${GL_LIB}|g" \
		-e "s|^\(GL_LIB_FLAGS =\).*|\1 ${GL_LIB_FLAGS}|g" \
		-e "s|^\(GL_INCLUDE_FLAGS =\).*|\1 ${GL_INCLUDE_FLAGS}|g" \
		-e "s|^\(GLUT_NEED_INIT =\).*|\1 ${GLUT_NEED_INIT}|g" \
		-e "s|^\(GLUT_NOT_IN_GL =\).*|\1|g" \
		-e "s|^\(X11_LIB_FLAGS =\).*|\1 -L${EPREFIX}/usr/$(get_libdir)|g" \
		-e "s|^\(TCL_LIB_FLAGS =\).*|\1 -L${EPREFIX}/usr/$(get_libdir)|g" \
		-e "s|^\(TK_LIB =\).*|\1 -ltk|g" \
		-e "s|^\(TK_LIB_FLAGS =\).*|\1 -L${EPREFIX}/usr/$(get_libdir)|g" \
		-e "s|^\(PYTHON_INCLUDE_FLAGS =\).*|\1 -I$(python_get_includedir)|g" \
		-e "s|^\(PYTHON_LIB =\).*|\1 -l${EPYTHON}|g" \
		c/environment_default.txt > c/environment.txt || die

	sed \
		-e 's:ln -s:cp -f:g' \
		-i $(find python -name linkSharedObjs) || die
}

src_compile() {
	emake -C c all
	emake -C c links
}

src_install() {
	local libdir
	local tkver
	local _wrapper

	find . -name "*.pyc" -type f -delete || die

	libdir=$(get_libdir)
	tkver=$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)

	_wrapper="analysis dangle dataShifter depositionFileImporter eci formatConverter pipe2azara xeasy2azara extendNmr"
	for wrapper in ${_wrapper}; do
		sed \
			-e "s|gentoo_sitedir|$(python_get_sitedir)|g" \
			-e "s|gentoolibdir|${EPREFIX}/usr/${libdir}|g" \
			-e "s|gentootk|${EPREFIX}/usr/${libdir}/tk${tkver}|g" \
			-e "s|gentootcl|${EPREFIX}/usr/${libdir}/tclk${tkver}|g" \
			-e "s|gentoopython|${EPYTHON}|g" \
			-e "s|gentoousr|${EPREFIX}/usr|g" \
			-e "s|//|/|g" \
			"${FILESDIR}"/${wrapper} > "${T}"/${wrapper} || die "Fail fix ${wrapper}"
		dobin "${T}"/${wrapper}
	done

	local in_path=$(python_get_sitedir)/${PN}
	local files
	local pydocs

	pydocs="$(find python -name doc -type d)"
	rm -rf ${pydocs} || die

	for i in python/memops/format/compatibility/{Converters,part2/Converters2}.py; do
	sed \
		-e 's|#from __future__|from __future__|g' \
		-i ${i} || die
	done

	dodir ${in_path#${EPREFIX}}/c

	ebegin "Installing main files"
		python_moduleinto ${PN}
		python_domodule python
	eend

	ebegin "Adjusting permissions"
	for _file in $(find "${ED}" -type f -name "*so"); do
		chmod 755 ${_file}
	done
	eend
	python_optimize
}
