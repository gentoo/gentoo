# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for AMD's closed source GPU video encode/decode binary driver"

SLOT="0"
KEYWORDS="-* amd64"

# See profiles/desc/amdgpu_targets.desc

# RDNA2 or older
LEGACY_TARGETS=(
	gfx803
	gfx900
	gfx906
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
)

# RDNA3 or newer
TARGETS=(
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1153
	gfx1200
	gfx1201
)

LEGACY_FLAGS="${LEGACY_TARGETS[*]/#/amdgpu_targets_}"
FLAGS="${TARGETS[*]/#/amdgpu_targets_}"

IUSE="${LEGACY_FLAGS} ${FLAGS}"

# Can only enable the targets that pull the legacy driver, xor the new driver
REQUIRED_USE="
	^^ (
		|| ( ${LEGACY_FLAGS} )
		|| ( ${FLAGS} )
	)
"

# RDNA2 or older: media-video/amdgpu-pro-amf-legacy
for flag in ${LEGACY_FLAGS}; do
	RDEPEND+=" ${flag}? ( media-video/amdgpu-pro-amf-legacy )"
done

# RDNA3 or newer: media-video/amdgpu-pro-amf
for flag in ${FLAGS}; do
	RDEPEND+=" ${flag}? ( media-video/amdgpu-pro-amf )"
done
