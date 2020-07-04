# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/OpenNI/OpenNI"
fi

inherit ${SCM} toolchain-funcs eutils multilib java-pkg-opt-2

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/OpenNI/OpenNI/archive/Stable-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-Stable-${PV}"
fi

DESCRIPTION="OpenNI SDK"
HOMEPAGE="https://github.com/OpenNI/OpenNI"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc java opengl"

RDEPEND="
	virtual/libusb:1
	virtual/libudev
	virtual/jpeg:0
	dev-libs/tinyxml
	opengl? ( media-libs/freeglut !dev-libs/OpenNI2[opengl] )
	java? ( >=virtual/jre-1.5 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 )"

src_prepare() {
	epatch \
		"${FILESDIR}/tinyxml.patch" \
		"${FILESDIR}/jpeg.patch" \
		"${FILESDIR}/soname.patch" \
		"${FILESDIR}/${P}-gcc6.patch"

	rm -rf External/{LibJPEG,TinyXml}
	for i in Platform/Linux/Build/Common/Platform.* Externals/PSCommon/Linux/Build/Platform.* ; do
		echo "" > ${i}
	done

	find . -type f -print0 | xargs -0 sed -i "s:\".*/SamplesConfig.xml:\"${EPREFIX}/usr/share/${PN}/SamplesConfig.xml:" || die
}

src_compile() {
	emake -C "${S}/Platform/Linux/Build" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		GLUT_SUPPORTED="$(usex opengl 1 0)" \
		$(usex java "" ALL_JAVA_PROJS="") \
		$(usex java "" JAVA_SAMPLES="") \
		ALL_MONO_PROJS="" \
		MONO_SAMPLES="" \
		MONO_FORMS_SAMPLES=""

	if use doc ; then
		cd "${S}/Source/DoxyGen"
		doxygen || die
	fi
}

src_install() {
	dolib.so "${S}/Platform/Linux/Bin/"*Release/*.so

	insinto /usr/include/openni
	doins -r Include/*

	dobin "${S}/Platform/Linux/Bin/"*Release/{ni*,Ni*,Sample-*}

	if use java ; then
		java-pkg_dojar "${S}/Platform/Linux/Bin/"*Release/*.jar
		echo "java -jar ${JAVA_PKG_JARDEST}/org.openni.Samples.SimpleViewer.jar" > org.openni.Samples.SimpleViewer
		dobin org.openni.Samples.SimpleViewer
	fi

	insinto /usr/share/${PN}
	doins Data/*

	dodoc Documentation/OpenNI_UserGuide.pdf CHANGES NOTICE README

	if use doc ; then
		dohtml -r "${S}/Source/DoxyGen/html/"*
		dodoc Source/DoxyGen/Text/*.txt
	fi

	keepdir /var/lib/ni
}

pkg_postinst() {
	if [ "${ROOT:-/}" = "/" ] ; then
		for i in "${EROOR}/usr/$(get_libdir)"/libnim*.so ; do
			einfo "Registering module ${i}"
			niReg -r "${i}"
		done
	fi
}
