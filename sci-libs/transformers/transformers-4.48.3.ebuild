# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow"
HOMEPAGE="
	https://pypi.org/project/transformers/
	https://huggingface.co/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # Need network, too long to execute

RDEPEND="
	=sci-libs/tokenizers-0.21*[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		sci-libs/huggingface_hub[${PYTHON_USEDEP}]
		>=sci-libs/safetensors-0.4.1[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/timeout-decorator[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest

src_test() {
	local EPYTEST_IGNORE=(
		tests/deepspeed/test_deepspeed.py
		tests/deepspeed/test_model_zoo.py
		tests/fsdp/test_fsdp.py
		tests/models/audio_spectrogram_transformer/test_feature_extraction_audio_spectrogram_transformer.py
		tests/models/bartpho/test_tokenization_bartpho.py
		tests/models/beit/test_image_processing_beit.py
		tests/models/big_bird/test_modeling_big_bird.py
		tests/models/clap/test_feature_extraction_clap.py
		tests/models/clip/test_image_processing_clip.py
		tests/models/clvp/test_feature_extraction_clvp.py
		tests/models/conditional_detr/test_image_processing_conditional_detr.py
		tests/models/cpm/test_tokenization_cpm.py
		tests/models/dac/test_feature_extraction_dac.py
		tests/models/encodec/test_feature_extraction_encodec.py
		tests/models/grounding_dino/test_image_processing_grounding_dino.py
		tests/models/idefics/test_image_processing_idefics.py
		tests/models/idefics2/test_image_processing_idefics2.py
		tests/models/layoutxlm/test_processor_layoutxlm.py
		tests/models/layoutxlm/test_tokenization_layoutxlm.py
		tests/models/llava_next/test_image_processing_llava_next.py
		tests/models/llava_next_video/test_image_processing_llava_next_video.py
		tests/models/llava_onevision/test_image_processing_llava_onevision.py
		tests/models/markuplm/test_feature_extraction_markuplm.py
		tests/models/marian/test_modeling_marian.py
		tests/models/mask2former/test_image_processing_mask2former.py
		tests/models/maskformer/test_image_processing_maskformer.py
		tests/models/mluke/test_tokenization_mluke.py
		tests/models/musicgen_melody/test_feature_extraction_musicgen_melody.py
		tests/models/nllb/test_tokenization_nllb.py
		tests/models/oneformer/test_image_processing_oneformer.py
		tests/models/oneformer/test_processor_oneformer.py
		tests/models/pix2struct/test_image_processing_pix2struct.py
		tests/models/pop2piano/test_feature_extraction_pop2piano.py
		tests/models/qwen2_audio/test_modeling_qwen2_audio.py
		tests/models/qwen2_vl/test_image_processing_qwen2_vl.py
		tests/models/seamless_m4t/test_feature_extraction_seamless_m4t.py
		tests/models/seamless_m4t/test_processor_seamless_m4t.py
		tests/models/segformer/test_image_processing_segformer.py
		tests/models/seggpt/test_image_processing_seggpt.py
		tests/models/speech_to_text/test_feature_extraction_speech_to_text.py
		tests/models/speech_to_text/test_processor_speech_to_text.py
		tests/models/speech_to_text/test_tokenization_speech_to_text.py
		tests/models/speecht5/test_feature_extraction_speecht5.py
		tests/models/speecht5/test_processor_speecht5.py
		tests/models/speecht5/test_tokenization_speecht5.py
		tests/models/superpoint/test_image_processing_superpoint.py
		tests/models/textnet/test_image_processing_textnet.py
		tests/models/trocr/test_processor_trocr.py
		tests/models/univnet/test_feature_extraction_univnet.py
		tests/models/vitpose/test_image_processing_vitpose.py
		tests/models/wav2vec2/test_feature_extraction_wav2vec2.py
		tests/models/whisper/test_feature_extraction_whisper.py
		tests/models/yolos/test_image_processing_yolos.py
		tests/repo_utils/test_check_docstrings.py
		tests/repo_utils/test_tests_fetcher.py
		tests/trainer/test_trainer.py
		tests/trainer/test_trainer_callback.py
		tests/trainer/test_trainer.py
		tests/trainer/test_trainer_callback.py
	)

	local EPYTEST_DESELECT=(
		tests/agents/test_agents.py::AgentTests::test_init_agent_with_different_toolsets
		tests/models/textnet/test_image_processing_textnet.py::TextNetImageProcessingTester
	)

	EPYTEST_FLAGS="--dist=loadfile -s ./tests/"

	distutils-r1_src_test
}
