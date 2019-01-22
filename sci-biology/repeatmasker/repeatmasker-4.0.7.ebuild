# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PV=${PV//\./-}

DESCRIPTION="Screen DNA sequences for interspersed repeats and low complexity DNA"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="http://www.repeatmasker.org/RepeatMasker-open-${MY_PV}.tar.gz"

LICENSE="OSL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	sci-biology/rmblast
	sci-biology/trf
	sci-biology/repeatmasker-libraries"

S="${WORKDIR}/RepeatMasker"

src_configure() {
	sed -i -e 's/system( "clear" );//' \
		-e 's|> \($rmLocation/Libraries/RepeatMasker.lib\)|> '${D}'/\1|' "${S}/configure" || die
	echo "
env
/usr/share/${PN}
/usr/bin
2
/opt/rmblast/bin
Y
5" | "${S}/configure" || die "configure failed"
	sed -i -e 's|use lib $FindBin::RealBin;|use lib "/usr/share/'${PN}'/lib";|' \
		-e 's|".*\(taxonomy.dat\)"|"/usr/share/'${PN}'/\1"|' \
		-e '/$REPEATMASKER_DIR/ s|$FindBin::RealBin|/usr/share/'${PN}'|' \
		"${S}"/{DateRepeats,ProcessRepeats,RepeatMasker,DupMasker,RepeatProteinMask,RepeatMaskerConfig.pm,Taxonomy.pm} || die
}

src_install() {
	exeinto /usr/share/${PN}
	for i in DateRepeats ProcessRepeats RepeatMasker DupMasker RepeatProteinMask; do
		doexe $i || die
		dosym /usr/share/${PN}/$i /usr/bin/$i || die
	done

	dodir /usr/share/${PN}/lib
	insinto /usr/share/${PN}/lib
	doins "${S}"/*.pm || die

	insinto /usr/share/${PN}
	doins -r util Matrices Libraries taxonomy.dat *.help || die
	keepdir /usr/share/${PN}/Libraries

	dodoc README INSTALL *.help
}
