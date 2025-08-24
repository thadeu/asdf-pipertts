# asdf-pipertts

Plugin for [asdf](https://asdf-vm.com/) and [mise](https://mise.jdx.dev/) that installs [Piper TTS](https://github.com/rhasspy/piper) - a fast, local neural text-to-speech system.

## 📋 Prerequisites

### System Dependencies

#### macOS
```bash
# Install via Homebrew
brew install python3 git curl jq

# Or via MacPorts
sudo port install python3 git curl jq
```

#### Ubuntu/Debian
```bash
# Update repositories
sudo apt update

# Install dependencies
sudo apt install -y python3 python3-venv python3-pip git curl jq
```

#### Other Linux distributions
```bash
# Fedora/RHEL/CentOS
sudo dnf install python3 python3-pip git curl jq

# Arch Linux
sudo pacman -S python python-pip git curl jq
```

## 🚀 Installation

### Install the plugin

#### For ASDF:
```bash
asdf plugin add pipertts https://github.com/seu-usuario/asdf-pipertts.git
```

#### For MISE:
```bash
mise plugin add pipertts https://github.com/seu-usuario/asdf-pipertts.git
```

### Install Piper TTS

```bash
# Install latest version
asdf install pipertts latest
# or
mise install pipertts@latest

# Install specific version
asdf install pipertts 1.2.0
# or
mise install pipertts@1.2.0

# Set as global version
asdf global pipertts latest
# or
mise use -g pipertts@latest
```

## 📦 What gets installed

The plugin installs:

- **`piper`** - Main CLI wrapper with automatic model management
- **`piper-list-models`** - Helper script to list available models
- **`piper-train-finetune`** - Script for model training and fine-tuning
- **Python virtual environment** with Piper TTS and training dependencies

## 🎯 How it works

### Automatic model management

The `piper` wrapper automatically manages voice models:

- **Smart directory detection**: Automatically detects whether you're using asdf or mise
- **Separate model storage**: Each voice is saved in its own directory to prevent overwriting
- **Friendly interface**: Use `-m faber` instead of full paths
- **Supported formats**: `.onnx` (voice model) + `.json` (config)
- **Source**: [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices)

### Directory detection

The plugin automatically detects the correct directory based on your package manager:

- **ASDF**: Uses `$ASDF_DATA_DIR/piper-models/`
- **MISE**: Uses `$MISE_DATA_DIR/piper-models/`
- **Fallback**: Uses `~/.local/share/piper-models/`

### Available voices

#### Portuguese (Brazil)
- **cadu** - Male voice, medium quality
- **edresson** - Male voice, medium quality
- **faber** - Male voice, medium quality
- **jeff** - Male voice, medium quality

#### English (US)
- **amy** - Female voice, medium quality
- **jenny** - Female voice, medium quality

## 💻 Usage examples

### Basic text-to-speech
```bash
# Download models first
piper --download-model pt_BR faber
piper --download-model pt_BR cadu

# Use friendly interface (no full paths needed!)
echo "Olá, mundo!" | piper -m faber --output_file hello.wav
echo "Hello, world!" | piper -m amy --output_file hello_en.wav

# Multiple voices work independently
echo "Teste com cadu" | piper -m cadu --output_file teste_cadu.wav
echo "Teste com faber" | piper -m faber --output_file teste_faber.wav
```

### Download models
```bash
# List available models
piper-list-models

# Download Brazilian voices (each saved separately)
piper --download-model pt_BR cadu
piper --download-model pt_BR edresson
piper --download-model pt_BR faber
piper --download-model pt_BR jeff

# Download English voice
piper --download-model en_US amy
```

### Model organization

Models are now organized by language and voice:

```
~/.local/share/piper-models/
├── pt_BR/
│   ├── cadu/
│   │   ├── voice.json
│   │   ├── voice.onnx
│   │   └── voice.onnx.json
│   ├── faber/
│   │   ├── voice.json
│   │   ├── voice.onnx
│   │   └── voice.onnx.json
│   └── edresson/
│       ├── voice.json
│       ├── voice.onnx
│       └── voice.onnx.json
└── en_US/
    └── amy/
        ├── voice.json
        ├── voice.onnx
        └── voice.onnx.json
```

### Convert text files
```bash
# Convert text file to speech
piper --model ~/.local/share/piper-models/pt_BR/faber/voice.onnx --input_file text.txt --output_file speech.wav

# Or use the friendly interface
echo "Conteúdo do arquivo" | piper -m faber --output_file speech.wav
```

### Quality and speed options
```bash
# Adjust speed (default: 1.0)
piper -m faber --speed 1.2 --output_file fast.wav

# Adjust noise scale (default: 0.667)
piper -m faber --noise_scale 0.5 --output_file clear.wav

# Adjust length scale (default: 1.0)
piper -m faber --length_scale 0.8 --output_file short.wav
```

### Batch processing
```bash
# Process multiple text files
for file in *.txt; do
    piper -m faber \
          --input_file "$file" \
          --output_file "${file%.txt}.wav"
done
```

### Using with ffmpeg (future feature)
```bash
# Convert to different formats
ffmpeg -i speech.wav -c:a mp3 speech.mp3

# Convert to different sample rates
ffmpeg -i speech.wav -ar 22050 speech_22k.wav

# Convert to different bitrates
ffmpeg -i speech.wav -b:a 128k speech_128k.mp3
```

## 🎓 Model Training and Fine-tuning

### Why train instead of text replacement?

**Text replacement problems:**
- ❌ Loses natural speech flow
- ❌ Creates awkward pauses
- ❌ Doesn't solve the root problem
- ❌ Requires constant rule maintenance

**Training advantages:**
- ✅ Model learns correct pronunciation
- ✅ Maintains natural speech flow
- ✅ Permanent solution
- ✅ Works with any variation

### Improving Brazilian Portuguese pronunciation

The plugin includes tools to fine-tune models for better Brazilian Portuguese pronunciation:

```bash
# Create training dataset
piper --create-dataset pt_BR faber

# This creates a dataset with examples like:
# R$ 1,00|money_1_real.wav
# 10%|percent_10.wav
# 2+3=5|math_2_plus_3.wav
```

### Training process

1. **Prepare training data:**
   ```bash
   # Create dataset template
   piper --create-dataset pt_BR faber
   ```

2. **Record audio samples:**
   - Record native Brazilian speaker reading the texts
   - Ensure high-quality audio (16kHz, mono)
   - Match audio files to text entries

3. **Fine-tune the model:**
   ```bash
   # Start fine-tuning process
   piper --finetune pt_BR faber
   ```

4. **Get training information:**
   ```bash
   # View detailed training guide
   piper-train-finetune
   ```

### Training requirements

- **Minimum dataset:** 100 audio samples
- **Audio quality:** 16kHz, mono, WAV format
- **Text variety:** Include monetary symbols, percentages, math operations
- **Speaker consistency:** Same speaker for all recordings

### Advanced training

For advanced fine-tuning, the plugin installs additional dependencies:
- PyTorch and TorchAudio
- Transformers library
- Datasets library

## 📁 File structure

```
~/.local/share/piper-models/
├── pt_BR/
│   ├── cadu/
│   │   ├── voice.json
│   │   ├── voice.onnx
│   │   ├── voice.onnx.json
│   │   └── training_data/
│   │       └── brazilian_texts.txt
│   ├── faber/
│   │   ├── voice.json
│   │   ├── voice.onnx
│   │   ├── voice.onnx.json
│   │   └── training_data/
│   │       └── brazilian_texts.txt
│   └── edresson/
│       ├── voice.json
│       ├── voice.onnx
│       └── voice.onnx.json
└── en_US/
    └── amy/
        ├── voice.json
        ├── voice.onnx
        └── voice.onnx.json
```

## 🔧 Advanced usage

### Using Python directly
```bash
# Activate the virtual environment
source ~/.local/share/mise/installs/pipertts/latest/venv/bin/activate

# Use piper Python module
python -m piper --help
```

### Custom model paths
```bash
# Use custom model directory
piper --model /path/to/custom/voice.onnx --output_file custom.wav

# Specify model directory
piper --model-dir /path/to/models --output_file output.wav
```



### Model resolution

The plugin supports multiple ways to specify models:

```bash
# By voice name (searches pt_BR first, then en_US)
piper -m faber --output_file teste.wav

# By language/voice
piper -m pt_BR/faber --output_file teste.wav

# By full path
piper -m /path/to/voice.onnx --output_file teste.wav
```

## 🐛 Troubleshooting

### Model download error
```bash
# Check connectivity
curl -I https://huggingface.co/rhasspy/piper-voices

# Manual download
mkdir -p ~/.local/share/piper-models/pt_BR/faber
curl -L -o ~/.local/share/piper-models/pt_BR/faber/voice.json \
  https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json
curl -L -o ~/.local/share/piper-models/pt_BR/faber/voice.onnx \
  https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx
```

### Python environment issues
```bash
# Recreate virtual environment
rm -rf ~/.local/share/mise/installs/pipertts/latest/venv
mise install pipertts@latest
```

### Permission issues
```bash
# Check permissions
ls -la ~/.local/share/piper-models/

# Fix permissions
chmod 755 ~/.local/share/piper-models/
```

### Training issues
```bash
# Check training dependencies
pip list | grep torch

# Reinstall training dependencies
pip install --upgrade torch torchaudio transformers datasets
```

### Model not found
```bash
# Check available models
piper-list-models

# Check model directory
echo "Model directory: $(get_model_dir)"

# Verify model files exist
ls -la ~/.local/share/piper-models/pt_BR/faber/
```

## 🚀 Future features

- Integration with ffmpeg for format conversion
- Support for more voice models
- Web interface for easy model management
- Batch processing with progress indicators
- Real-time streaming TTS
- Advanced fine-tuning scripts
- Model evaluation tools

## 📚 Additional resources

- [Official Piper TTS documentation](https://github.com/rhasspy/piper)
- [Available voices on Hugging Face](https://huggingface.co/rhasspy/piper-voices)
- [Brazilian voices directory](https://huggingface.co/rhasspy/piper-voices/tree/main/pt/pt_BR)
- [Piper TTS Python package](https://pypi.org/project/piper-tts/)
- [Coqui TTS for advanced training](https://github.com/coqui-ai/TTS)
- [Fine-tuning guide](https://github.com/rhasspy/piper#training)

## 🤝 Contributing

Contributions are welcome! Please open an issue or pull request.

## 📄 License

This project is licensed under the same license as Piper TTS.