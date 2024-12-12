import os
import yaml
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

if __name__ == "__main__":
    original_yaml_path = 'yaml/original/api_config.yaml'
    updated_yaml_path = 'yaml/generated/api_config_updated.yaml'

    os.makedirs(os.path.dirname(updated_yaml_path), exist_ok=True)

    try:
        with open(original_yaml_path, 'r') as file:
            config = yaml.safe_load(file)
        logger.info(f"Successfully read original YAML file from {original_yaml_path}")

        new_config = {
            'model_name_or_path': config['model_name_or_path'],
            'adapter_name_or_path': config['adapter_name_or_path'],
            'template': config['template'],
            'infer_backend': config['infer_backend']
        }

        if config['infer_backend'] == 'vllm':
            new_config['vllm_enforce_eager'] = config['vllm_enforce_eager']
            new_config['vllm_gpu_util'] = config['vllm_gpu_util']
            new_config['vllm_maxlen'] = config['vllm_maxlen']
        elif config['infer_backend'] == 'huggingface':
            new_config['cutoff_len'] = config['cutoff_len']

        logger.info("Added new values to the configuration")

        with open(updated_yaml_path, 'w') as file:
            yaml.safe_dump(new_config, file, default_flow_style=False)
        logger.info(f"Updated YAML file saved to {updated_yaml_path}")

    except FileNotFoundError as e:
        logger.error(f"File not found: {e}")
        raise
    except yaml.YAMLError as e:
        logger.error(f"Error processing YAML file: {e}")
        raise
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        raise
