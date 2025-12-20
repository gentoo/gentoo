# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data files for Geant4 physical processes"
HOMEPAGE="https://geant4.web.cern.ch"
SRC_DATA="https://geant4-data.web.cern.ch/geant4-data/datasets"

S="${WORKDIR}"

LICENSE="geant4"

SLOT="4"
KEYWORDS="~amd64 ~x86"

declare -A DATASETS

DATASETS=(
	[G4NDL]="G4NDL 4.7.1 G4NEUTRONHPDATA"
	[G4EMLOW]="G4EMLOW 8.8 G4LEDATA"
	[PhotonEvaporation]="G4PhotonEvaporation 6.1.2 G4LEVELGAMMADATA"
	[RadioactiveDecay]="G4RadioactiveDecay 6.1.2 G4RADIOACTIVEDATA"
	[G4PARTICLEXS]="G4PARTICLEXS 4.2 G4PARTICLEXSDATA"
	[G4PII]="G4PII 1.3 G4PIIDATA"
	[RealSurface]="G4RealSurface 2.2 G4REALSURFACEDATA"
	[G4SAIDDATA]="G4SAIDDATA 2.0 G4SAIDXSDATA"
	[G4ABLA]="G4ABLA 3.3 G4ABLADATA"
	[G4INCL]="G4INCL 1.3 G4INCLDATA"
	[G4ENSDFSTATE]="G4ENSDFSTATE 3.0 G4ENSDFSTATEDATA"
	[G4CHANNELING]="G4CHANNELING 2.0 G4CHANNELINGDATA"
	[G4TENDL]="G4TENDL 1.4 G4PARTICLEHPDATA"
	[G4NUDEXLIB]="G4NUDEXLIB 1.0 G4NUDEXLIBDATA"
	[G4URRPT]="G4URRPT 1.1 G4URRPTDATA"
)

for DATASET in ${!DATASETS[@]}; do
	read FILENAME VERSION ENVVAR <<< "${DATASETS[$DATASET]}"
	SRC_URI+="${SRC_DATA}/${FILENAME}.${VERSION}.tar.gz "
done
unset DATASET FILENAME VERSION ENVVAR

src_unpack() {
	# unpack in destination only to avoid copy
	return
}

src_install() {
	dodir /usr/share/geant4/data
	cd "${ED}/usr/share/geant4/data" || die
	unpack ${A}
}
