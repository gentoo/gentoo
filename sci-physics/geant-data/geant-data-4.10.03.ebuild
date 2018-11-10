# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Data files for Geant4 physical processes"
HOMEPAGE="http://geant4.cern.ch/"

GEANT4_DATA="
	G4NDL.4.5
	G4EMLOW.6.50
	G4PhotonEvaporation.4.3
	G4RadioactiveDecay.5.1
	G4SAIDDATA.1.1
	G4NEUTRONXS.1.4
	G4ABLA.3.0
	G4PII.1.3
	RealSurface.1.0
	G4ENSDFSTATE.2.1
	G4TENDL.1.3"

SRC_COM="http://geant4.cern.ch/support/source"
for d in ${GEANT4_DATA}; do
	SRC_URI="${SRC_URI} ${SRC_COM}/${d}.tar.gz"
done
unset d

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=sci-physics/geant-${PV}:4"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	# unpack in destination only to avoid copy
	return
}

src_install() {
	sed -n "s,export \(G4.\+DATA=\"\).*\(/share/Geant.\+/data/.\+\) > /dev/null ; pwd\`,\1${EPREFIX}/usr\2,p" \
		"${EPREFIX}/usr/bin/geant4.sh" > 99geant-data || die
	doenvd 99geant-data
	local g4dir=/usr/$(sed -n 's|.*/\(share/Geant4.*/data\).*|\1|p' "${EPREFIX}/usr/bin/geant4.sh" | tail -n 1)
	dodir ${g4dir}
	cd "${ED%/}/${g4dir}" || die
	unpack ${A}
}
