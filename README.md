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
- **Python virtual environment** with Piper TTS and dependencies

## 🎯 How it works

### Automatic model management

The `piper` wrapper automatically manages voice models:

- Models are saved in `~/.local/share/mise/piper-models/`
- Supported formats: `.onnx` (voice model) + `.json` (config)
- Source: [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices)

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
# Convert text to speech (requires model download first)
echo "Olá, mundo!" | piper --model ~/.local/share/mise/piper-models/pt_BR/voice.onnx --output_file hello.wav

# Or use the wrapper with automatic model management
echo "Hello, world!" | piper --download-model en_US amy --output_file hello.wav
```

### Download models
```bash
# List available models
piper-list-models

# Download Brazilian voices
piper --download-model pt_BR cadu
piper --download-model pt_BR edresson
piper --download-model pt_BR faber
piper --download-model pt_BR jeff

# Download English voice
piper --download-model en_US amy
```

### Convert text files
```bash
# Convert text file to speech
piper --model ~/.local/share/mise/piper-models/pt_BR/voice.onnx --input_file text.txt --output_file speech.wav

# With specific voice
piper --model ~/.local/share/mise/piper-models/en_US/voice.onnx --input_file english.txt --output_file english_speech.wav
```

### Quality and speed options
```bash
# Adjust speed (default: 1.0)
piper --model voice.onnx --speed 1.2 --output_file fast.wav

# Adjust noise scale (default: 0.667)
piper --model voice.onnx --noise_scale 0.5 --output_file clear.wav

# Adjust length scale (default: 1.0)
piper --model voice.onnx --length_scale 0.8 --output_file short.wav
```

### Batch processing
```bash
# Process multiple text files
for file in *.txt; do
    piper --model ~/.local/share/mise/piper-models/pt_BR/voice.onnx \
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

## 📁 File structure

```
~/.local/share/mise/piper-models/
├── pt_BR/
│   ├── voice.json
│   ├── voice.onnx
│   └── voice.onnx.json
└── en_US/
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

## 🐛 Troubleshooting

### Model download error
```bash
# Check connectivity
curl -I https://huggingface.co/rhasspy/piper-voices

# Manual download
mkdir -p ~/.local/share/mise/piper-models/pt_BR
curl -L -o ~/.local/share/mise/piper-models/pt_BR/voice.json \
  https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json
curl -L -o ~/.local/share/mise/piper-models/pt_BR/voice.onnx \
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
ls -la ~/.local/share/mise/piper-models/

# Fix permissions
chmod 755 ~/.local/share/mise/piper-models/
```

## 🚀 Future features

- Integration with ffmpeg for format conversion
- Support for more voice models
- Web interface for easy model management
- Batch processing with progress indicators
- Real-time streaming TTS

## 📚 Additional resources

- [Official Piper TTS documentation](https://github.com/rhasspy/piper)
- [Available voices on Hugging Face](https://huggingface.co/rhasspy/piper-voices)
- [Brazilian voices directory](https://huggingface.co/rhasspy/piper-voices/tree/main/pt/pt_BR)
- [Piper TTS Python package](https://pypi.org/project/piper-tts/)

## 🤝 Contributing

Contributions are welcome! Please open an issue or pull request.

## 📄 License

This project is licensed under the same license as Piper TTS.