# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Data files for Geant4 physical processes"
HOMEPAGE="https://geant4.web.cern.ch"
SRC_DATA="https://geant4-data.web.cern.ch/geant4-data/datasets"

declare -A DATASETS

DATASETS=(
	[G4NDL]="G4NDL 4.6 G4NEUTRONHPDATA"
	[G4EMLOW]="G4EMLOW 7.13 G4LEDATA"
	[PhotonEvaporation]="G4PhotonEvaporation 5.7 G4LEVELGAMMADATA"
	[RadioactiveDecay]="G4RadioactiveDecay 5.6 G4RADIOACTIVEDATA"
	[G4PARTICLEXS]="G4PARTICLEXS 3.1.1 G4PARTICLEXSDATA"
	[G4PII]="G4PII 1.3 G4PIIDATA"
	[RealSurface]="G4RealSurface 2.2 G4REALSURFACEDATA"
	[G4SAIDDATA]="G4SAIDDATA 2.0 G4SAIDXSDATA"
	[G4ABLA]="G4ABLA 3.1 G4ABLADATA"
	[G4INCL]="G4INCL 1.0 G4INCLDATA"
	[G4ENSDFSTATE]="G4ENSDFSTATE 2.3 G4ENSDFSTATEDATA"
	[G4TENDL]="G4TENDL 1.3.2 G4PARTICLEHPDATA"
)

for DATASET in ${!DATASETS[@]}; do
	read FILENAME VERSION ENVVAR <<< "${DATASETS[$DATASET]}"
	SRC_URI+="${SRC_DATA}/${FILENAME}.${VERSION}.tar.gz "
done
unset DATASET FILENAME VERSION ENVVAR

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	# unpack in destination only to avoid copy
	return
}

src_install() {
	for DATASET in ${!DATASETS[@]}; do
		read FILENAME VERSION ENVVAR <<< "${DATASETS[$DATASET]}"
		echo $ENVVAR=\"${EPREFIX}/usr/share/geant4/data/${DATASET}${VERSION}\";
	done >| 99geant-data
	doenvd 99geant-data
	dodir /usr/share/geant4/data
	cd "${ED}/usr/share/geant4/data" || die
	unpack ${A}
}
