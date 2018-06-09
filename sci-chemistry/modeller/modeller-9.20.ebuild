# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils multilib versionator

DESCRIPTION="Homology or comparative modeling of protein three-dimensional structures"
HOMEPAGE="https://salilab.org/modeller/"
SRC_URI="https://salilab.org/${PN}/${PV}/${P}.tar.gz"

LICENSE="modeller"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"
SLOT="0"

RESTRICT="mirror"

DEPEND=">=dev-lang/swig-1.3"
RDEPEND=""

INPATH="${EPREFIX}"/opt/modeller${ver}

QA_PREBUILT="/opt/*"

pkg_setup() {
	case ${ARCH} in
		x86)
			EXECTYPE="i386-intel8";;
		amd64)
			EXECTYPE="x86_64-intel8";;
		*)
			die "Your arch "${ARCH}" does not appear supported at this time.";;
	esac
}

python_prepare_all(){
	sed "s:i386-intel8:${EXECTYPE}:g" -i src/swig/setup.py || die
	distutils-r1_python_prepare_all
}

python_compile(){
	cd src/swig || die
	swig -python -keyword -nodefaultctor -nodefaultdtor -noproxy modeller.i || die
	distutils-r1_python_compile
}

python_install() {
	cd src/swig || die
	distutils-r1_python_install
}

python_install_all(){
	cd "${S}" || die
	sed \
		-e "/^EXECUTABLE_TYPE/s:xxx:${EXECTYPE}:g" \
		-e "/MODINSTALL/s:xxx:\"${INPATH}\":g" \
		-i bin/modscript || die

	sed -e "s;@TOPDIR\@;\"${INPATH}\";" \
		-e "s;@EXETYPE\@;${EXECTYPE};" \
		bin/modpy.sh.in > "${T}/modpy.sh"

	insinto ${INPATH}
	doins -r modlib
	python_foreach_impl python_domodule modlib/modeller

	insinto ${INPATH}/bin
	doins -r bin/{lib,*top}

	exeinto ${INPATH}/bin
	doexe bin/{modscript,mod${PV}_${EXECTYPE}} "${T}"/modpy.sh

	python_foreach_impl python_doscript bin/modslave.py
	dosym ${INPATH}/bin/modscript /opt/bin/mod${PV}
	dosym ${INPATH}/bin/modpy.sh /opt/bin/modpy.sh

	exeinto ${INPATH}/lib/${EXECTYPE}/
	doexe lib/${EXECTYPE}/lib*
	dosym libmodeller.so.8 ${INPATH}/lib/${EXECTYPE}/libmodeller.so
	dosym ../../${INPATH}/lib/${EXECTYPE}/libmodeller.so.8 /usr/$(get_libdir)/libmodeller.so.8

	use doc && HTML_DOCS=( doc/. )
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples
	fi

	insinto /etc/revdep-rebuild
	cat >> "${T}"/40-${PN} <<- EOF
	SEARCH_DIRS_MASK="${EPREFIX}/opt/modeller/lib/"
	EOF
	doins "${T}"/40-${PN}
}

pkg_postinst() {
	if [[ ! -e "${INPATH}/modlib/modeller/config.py" ]]; then
		echo install_dir = \"${INPATH}/\"> ${INPATH}/modlib/modeller/config.py
	fi

	if grep -q license ${INPATH}/modlib/modeller/config.py; then
		einfo "A license key file is already present in ${IN_PATH}/modlib/modeller/config.py"
	else
		ewarn "Obtain a license Key from"
		ewarn "http://salilab.org/modeller/registration.html"
		ewarn "And run this before using modeller:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your license key."
	fi
}

pkg_postrm() {
	ewarn "This package leaves a license Key file in ${INPATH}/modlib/modeller/config.py"
	ewarn "that you need to remove to completely get rid of modeller."
}

pkg_config() {
	ewarn "Your license key is NOT checked for validity here."
	ewarn "  Make sure you type it in correctly."
	eerror "If you CTRL+C out of this, modeller will not run!"
	while true
	do
		einfo "Please enter your license key:"
		read license_key1
		einfo "Please re-enter your license key:"
		read license_key2
		if [[ "$license_key1" == "" ]]
		then
			echo "You entered a blank license key.  Try again."
		else
			if [[ "$license_key1" == "$license_key2" ]]
			then
				echo license = '"'$license_key1'"' >> "${INPATH}/modlib/modeller/config.py"
				einfo "Thank you!"
				break
			else
				eerror "Your license key entries do not match.  Try again."
			fi
		fi
	done
}
